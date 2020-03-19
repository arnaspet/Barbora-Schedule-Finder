defmodule Barbora.Client do
  use Tesla

  def get_deliveries(client) do
    get!(client, "/api/eshop/v1/cart/deliveries")
  end

  def client() do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://www.barbora.lt"},
      Tesla.Middleware.FormUrlencoded,
      Tesla.Middleware.DecodeJson,
      # fun fact: this header must be set :D which decodes to: apikey:SecretKey
      {Tesla.Middleware.Headers, [{"Authorization", "Basic YXBpa2V5OlNlY3JldEtleQ=="}]}
    ]

    client = Tesla.client(middleware)

    Tesla.client([{Tesla.Middleware.Headers, [{"Cookie", get_login_cookie(client)}]} | middleware])
  end

  defp get_login_cookie(client) do
    response =
      post!(
        client,
        "/api/eshop/v1/user/login",
        %{
          email: email(),
          password: password(),
          rememberMe: true
        }
      )

    Enum.reduce(response.headers, "", fn
      {"set-cookie", cookie}, acc -> acc <> cookie <> "; "
      _, acc -> acc
    end)
  end

  defp email(), do: Application.fetch_env!(:barbora, Barbora.Client)[:email]
  defp password(), do: Application.fetch_env!(:barbora, Barbora.Client)[:password]
end
