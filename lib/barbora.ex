defmodule Barbora do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Registry, [:unique, :telegram_users]),
      {DynamicSupervisor, strategy: :one_for_one, name: Barbora.Telegram.UsersDynamicSupervisor},
      {Barbora.Telegram.Poller, []}
    ]

    opts = [strategy: :one_for_one, name: Barbora.Telegram.Supervisor]
    supervisor = Supervisor.start_link(children, opts)
    Barbora.Telegram.start_user_checkers()

    supervisor
  end
end
