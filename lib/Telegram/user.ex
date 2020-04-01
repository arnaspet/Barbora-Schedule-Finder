defmodule Barbora.Telegram.User do
  require Logger

  def notify([], chat_id) do
    Logger.debug("No timeslots found for #{chat_id}")
    :no_timeslots
  end

  def notify(timeslots, chat_id) do
    formatted_slots =
      Enum.reduce(timeslots, "", fn slot, acc -> "#{acc} #{slot["deliveryTime"]}\n" end)

    Logger.debug("New available slots for #{chat_id} #{formatted_slots}")
    Nadia.send_message(chat_id, "New available slots!: #{formatted_slots}")
  end
end
