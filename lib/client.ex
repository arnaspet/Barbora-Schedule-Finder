defmodule Barbora.Client do
  use Tesla

  def get_deliveries(client) do
    get!(client, "/api/eshop/v1/cart/deliveries")
  end

  @spec client({String.t(), String.t()}) :: Tesla.Client.t()
  def client(auth) do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://www.barbora.lt"},
      Tesla.Middleware.FormUrlencoded,
      Tesla.Middleware.DecodeJson,
      # fun fact: this header must be set :D which decodes to: apikey:SecretKey
      {Tesla.Middleware.Headers, [{"Authorization", "Basic YXBpa2V5OlNlY3JldEtleQ=="}]}
    ]

    client = Tesla.client(middleware)

    Tesla.client([{Tesla.Middleware.Headers, [{"Cookie", get_login_cookie(client, auth)}]} | middleware])
  end

  defp get_login_cookie(client, {email, password}) do
    response =
      post!(
        client,
        "/api/eshop/v1/user/login",
        %{
          email: email,
          password: password,
          rememberMe: true
        }
      )

    Enum.reduce(response.headers, "", fn
      {"set-cookie", cookie}, acc -> acc <> cookie <> "; "
      _, acc -> acc
    end)
  end
end
