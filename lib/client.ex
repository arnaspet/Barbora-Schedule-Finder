defmodule Barbora.Client do
  use Tesla
  require Logger

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
      {Tesla.Middleware.Headers, [{"Authorization", "Basic YXBpa2V5OlNlY3JldEtleQ=="}]}
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
    case post!(
           client,
           "/api/eshop/v1/user/login",
           %{
             email: email,
             password: password,
             rememberMe: true
           }
         ) do
      %Tesla.Env{status: 200, headers: headers} ->
        {:ok, generate_cookie(headers)}

      %Tesla.Env{status: status, body: body} ->
        Logger.info("Request failed: #{inspect(body)}")
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
