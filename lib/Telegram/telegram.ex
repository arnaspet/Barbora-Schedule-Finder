defmodule Barbora.Telegram do
  use Application
  alias :dets, as: Dets
  @users_table :users

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Registry, [:unique, :telegram_users]),
      {DynamicSupervisor, strategy: :one_for_one, name: Barbora.Telegram.UsersDynamicSupervisor},
      {Barbora.Telegram.Poller, []}
    ]

    opts = [strategy: :one_for_one, name: Barbora.Telegram.Supervisor]
    supervisor = Supervisor.start_link(children, opts)
    start_user_checkers()

    supervisor
  end

  def start_user_checkers() do
    {:ok, table} = Dets.open_file(@users_table, type: :set)

    Dets.select(table, [{:"$1", [], [:"$1"]}])
    |> Enum.each(&register_to_supervisor/1)
  end

  def add_user(user) do
    Dets.insert(@users_table, user)
    register_to_supervisor(user)
    Dets.close(@users_table)
  end

  defp register_to_supervisor(user) do
    DynamicSupervisor.start_child(
      Barbora.Telegram.UsersDynamicSupervisor,
      {Barbora.Telegram.User, user}
    )
  end
end
