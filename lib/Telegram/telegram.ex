defmodule Barbora.Telegram do
  alias :dets, as: Dets
  @users_table :users

  def start_user_checkers() do
    {:ok, table} = Dets.open_file(@users_table, type: :set)
    users = Dets.select(table, [{:"$1", [], [:"$1"]}])
    Dets.close(table)

    users |> Enum.each(&register_to_supervisor/1)
  end

  def add_user(user) do
    {:ok, table} = Dets.open_file(@users_table, type: :set)
    Dets.insert(table, user)
    register_to_supervisor(user)
    Dets.close(table)
  end

  defp register_to_supervisor(user) do
    DynamicSupervisor.start_child(
      Barbora.Telegram.UsersDynamicSupervisor,
      {Barbora.Telegram.User, user}
    )
  end
end
