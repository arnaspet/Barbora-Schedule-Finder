defmodule Barbora.Telegram.UsersDynamicSupervisor do
  require Logger
  use DynamicSupervisor
  alias :dets, as: Dets
  @users_table :users

  def start_link(init_arg) do
    Task.start(&start_user_checkers/0)
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_user_checkers() do
    Logger.debug("Starting up user scanners from dets")

    dets_command(&Dets.select(&1, [{:"$1", [], [:"$1"]}]))
    |> Enum.each(fn user ->
      Task.async(fn ->
        Process.sleep(:rand.uniform(60 * 1000))
        register_to_supervisor(user)
      end)
    end)
  end

  defp register_to_supervisor(user) do
    DynamicSupervisor.start_child(
      Barbora.Telegram.UsersDynamicSupervisor,
      {Barbora.Telegram.UserGenServer, user}
    )
  end

  def add_user(user) do
    dets_command(&Dets.insert(&1, user))
    register_to_supervisor(user)
  end

  def remove_user(chat_id) do
    dets_command(&Dets.delete(&1, chat_id))

    [{user_pid, _}] = Registry.lookup(:telegram_users, chat_id)
    DynamicSupervisor.terminate_child(Barbora.Telegram.UsersDynamicSupervisor, user_pid)
  end

  def dets_command(function) do
    {:ok, table} = Dets.open_file(@users_table, type: :set)
    return = function.(table)
    Dets.close(table)

    return
  end
end
