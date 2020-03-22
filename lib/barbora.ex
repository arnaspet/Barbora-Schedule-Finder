defmodule Barbora do
  use Application
  @notifier Application.fetch_env!(:barbora, :notifier)
  @loginProvider Application.fetch_env!(:barbora, :login_provider)

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Registry, [:unique, :telegram_users]),
      Barbora.Scheduler
    ]

    opts = [strategy: :one_for_one, name: Barbora.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def check_deliveries() do
    Barbora.Client.client(@loginProvider.provide())
    |> Barbora.Client.get_deliveries()
    |> Barbora.Deliveries.filter_available_deliveries()
    |> @notifier.notify()
  end
end
