defmodule Barbora.Client do
  use Tesla
  require Logger

#  plug Tesla.Middleware.Logger

  def get_deliveries(client) do
    get!(client, "/api/eshop/v1/cart/deliveries")
  end

  @spec client({String.t(), String.t()}) :: Tesla.Client.t() | {:error, integer}
  def client(auth) do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://www.barbora.lt"},
      Tesla.Middleware.FormUrlencoded,
      Tesla.Middleware.DecodeJson,
      # fun fact: this header must be set :D which decodes to: apikey:SecretKey
      {Tesla.Middleware.Headers, [
        {"Authorization", "Basic YXBpa2V5OlNlY3JldEtleQ=="},
        {"User-Agent", "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.149 Safari/537.36}"},
      ]}
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
        {:ok, generate_cookie(headers)}

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
