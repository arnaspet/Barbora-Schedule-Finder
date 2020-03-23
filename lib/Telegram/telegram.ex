defmodule Barbora.Telegram do
  alias :dets, as: Dets
  @users_table :users

  def start_user_checkers() do
    dets_command(&Dets.select(&1, [{:"$1", [], [:"$1"]}]))
    |> Enum.each(fn user ->
      Task.async(fn ->
        Process.sleep(:rand.uniform(60))
        register_to_supervisor(user)
      end)
    end)
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

  defp register_to_supervisor(user) do
    DynamicSupervisor.start_child(
      Barbora.Telegram.UsersDynamicSupervisor,
      {Barbora.Telegram.User, user}
    )
  end

  def dets_command(function) do
    {:ok, table} = Dets.open_file(@users_table, type: :set)
    return = function.(table)
    Dets.close(table)

    return
  end
end
