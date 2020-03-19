defmodule Barbora do
  use Application
  @notifier Application.fetch_env!(:barbora, :notifier)

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      Barbora.Scheduler
    ]

    opts = [strategy: :one_for_one, name: Barbora.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def check_deliveries() do
    Barbora.Client.client()
    |> Barbora.Client.get_deliveries()
    |> Barbora.Deliveries.filter_available_deliveries()
    |> @notifier.provide()
  end
end
