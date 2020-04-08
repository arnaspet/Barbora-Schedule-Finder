defmodule Barbora.Telegram.User do
  require Logger

  def send_message(chat_id, message) do
    Logger.debug("Sending message to #{chat_id}: #{message}")
    Nadia.send_message(chat_id, message)
  end

  def answer_callback(callback_id, message) do
    Logger.debug("answering query for #{callback_id} -> #{message}")
    Nadia.answer_callback_query(callback_id, text: message)
  end

  def notify_timeslots([], chat_id) do
    Logger.debug("No timeslots found for #{chat_id}")
    :no_timeslots
  end

  def notify_timeslots(timeslots, chat_id) do
    formatted_slots =
      Enum.map(timeslots, fn slot ->
        [
          %Nadia.Model.InlineKeyboardButton{
            callback_data: "/reserve #{slot["id"]} #{slot["day_id"]}",
            text: NaiveDateTime.from_iso8601!(slot["deliveryTime"]) |> NaiveDateTime.to_string()
          }
        ]
      end)

    Logger.debug("New available slots for #{chat_id} #{inspect(formatted_slots)}")

    Nadia.send_message(chat_id, "New available slots found! You can reserve your time",
      reply_markup: %Nadia.Model.InlineKeyboardMarkup{inline_keyboard: formatted_slots}
    )
  end
end
