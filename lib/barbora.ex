defmodule Barbora do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Registry, [:unique, :telegram_users]),
      {Barbora.Telegram.UsersDynamicSupervisor, strategy: :one_for_one},
      {Barbora.Telegram.Poller, []}
    ]

    opts = [strategy: :one_for_one, name: Barbora.Telegram.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
