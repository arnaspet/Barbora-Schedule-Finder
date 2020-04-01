defmodule Barbora.Telegram.UserGenServer do
  use GenServer
  require Logger

  @scan_interval 60 * 1000

  def start_link({chat_id, auth}),
    do: GenServer.start_link(__MODULE__, {chat_id, auth}, name: via_tuple(chat_id))

  defp via_tuple(chat_id), do: {:via, Registry, {:telegram_users, chat_id}}

  def init({chat_id, auth}) do
    Logger.debug("Initiating #{chat_id} user scanner")

    case Barbora.Client.client(auth) do
      %Tesla.Client{} = client ->
        {:ok, %{chat_id: chat_id, auth: auth, client: client}, @scan_interval}

      {:error, _} ->
        {:stop, :normal}
    end
  end

  def scan(chat_id), do: GenServer.cast(via_tuple(chat_id), {:scan})

  def handle_info(:timeout, state) do
    scan(state.chat_id)
    {:noreply, state}
  end

  def handle_cast({:scan}, state) do
    Logger.debug("Scanning for deliveries for chat: #{state.chat_id}")

    state.client
    |> Barbora.Client.get_deliveries()
    |> Barbora.Deliveries.filter_available_deliveries()
    |> Barbora.Telegram.User.notify(state.chat_id)

    {:noreply, state, @scan_interval}
  end
end
