defmodule Barbora.LoginProvider.Config do
  def provide() do
    {Application.fetch_env!(:barbora, Barbora.LoginProvider.Config)[:email],
     Application.fetch_env!(:barbora, Barbora.LoginProvider.Config)[:password]}
  end
end
