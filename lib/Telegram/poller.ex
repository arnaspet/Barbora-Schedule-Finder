defmodule Barbora.Telegram.Poller do
  use GenServer
  require Logger

  def start_link(_) do
    Logger.debug("Started poller")
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    update()
    {:ok, 0}
  end

  def handle_cast(:update, offset) do
    new_offset =
      Nadia.get_updates(offset: offset)
      |> process_messages

    {:noreply, new_offset + 1, 100}
  end

  def handle_info(:timeout, offset) do
    update()
    {:noreply, offset}
  end

  # Client

  def update do
    GenServer.cast(__MODULE__, :update)
  end

  # Helpers

  defp process_messages({:ok, []}), do: -1

  defp process_messages({:ok, results}) do
    results
    |> Enum.map(fn %{update_id: id} = message ->
      message
      |> process_message

      id
    end)
    |> List.last()
  end

  defp process_messages({:error, %Nadia.Model.Error{reason: reason}}) do
    Logger.log(:error, reason)

    -1
  end

  defp process_message(message) do
    try do
      Barbora.Telegram.Matcher.match(message)
    rescue
      err in MatchError ->
        Logger.log(:warn, "Errored with #{inspect(err)} at #{inspect(message)}")
    end
  end
end
