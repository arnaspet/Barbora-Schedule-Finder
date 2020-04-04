defmodule Barbora.Client do
  use Tesla
  require Logger

  @headers [
    # fun fact: this header must be set :D which decodes to: apikey:SecretKey
    {"Authorization", "Basic YXBpa2V5OlNlY3JldEtleQ=="},
    {"User-Agent",
     "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.149 Safari/537.36}"}
  ]

  #  plug Tesla.Middleware.Logger

  def get_deliveries(client) do
    with %Tesla.Env{status: 200, body: body} <- get!(client, "/api/eshop/v1/cart/deliveries"),
         do: body
  end

  @spec reserve_delivery(%Tesla.Client{}, {String.t(), String.t()}) ::
          :ok | {:err, :already_taken} | {:err, :unknown}
  def reserve_delivery(client, {hourId, dayId}) do
    with %Tesla.Env{body: %{"deliveries" => _deliveries}} <-
           post!(client, "/api/eshop/v1/cart/ReserveDeliveryTimeSlot", %{
             dayId: dayId,
             hourId: hourId
           }) do
      :ok
    else
      %Tesla.Env{body: %{"messages" => %{"error" => [%{"Id" => "time_reservation_needed"} | _]}}} ->
        {:err, :already_taken}

      err ->
        Logger.error("Reservation request failed #{inspect(err)}")
        {:err, :unknown}
    end
  end

  @spec client({String.t(), String.t()}) :: Tesla.Client.t() | {:error, integer}
  def client(auth) do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://www.barbora.lt"},
      Tesla.Middleware.FormUrlencoded,
      Tesla.Middleware.DecodeJson,
      {Tesla.Middleware.Headers, @headers}
    ]

    client = Tesla.client(middleware)

    case get_login_cookie(client, auth) do
      {:ok, cookie} ->
        Tesla.client([
          {Tesla.Middleware.Headers, [{"Cookie", cookie}]} | middleware
        ])

      err ->
        err
    end
  end

  defp get_login_cookie(client, {email, password}) do
    %Tesla.Env{headers: headers} = get!(client, "")
    cookie = generate_cookie([{"set-cookie", "region=barbora.lt"} | headers])

    case post!(
           client,
           "/api/eshop/v1/user/login",
           %{
             email: email,
             password: password,
             rememberMe: true
           },
           headers: [{"Cookie", cookie}]
         ) do
      %Tesla.Env{status: 200, headers: headers} ->
        {:ok, generate_cookie([{"set-cookie", "region=barbora.lt"} | headers])}

      %Tesla.Env{status: status} = err ->
        Logger.info("Request failed: #{inspect(err)}")
        {:error, status}
    end
  end

  defp generate_cookie(headers) do
    Enum.reduce(headers, "", fn
      {"set-cookie", cookie}, acc -> acc <> cookie <> "; "
      _, acc -> acc
    end)
  end
end
