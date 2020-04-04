defmodule Barbora.Telegram.Matcher do
  require Logger

  @greeting """
  Please provider email and password to barbora website in format like so:
    /auth myemail@email.com password
  """

  def match(%Nadia.Model.Update{
        message: %Nadia.Model.Message{text: text, chat: %Nadia.Model.Chat{id: chat_id}}
      }) do
    match_text(text, chat_id)
  end

  def match(%Nadia.Model.Update{
        callback_query: %Nadia.Model.CallbackQuery{
          id: callback_id,
          data: "/reserve " <> reservation,
          message: %Nadia.Model.Message{chat: %Nadia.Model.Chat{id: chat_id}}
        }
      }) do
    [hour_id, day_id] = String.split(reservation, " ")
    Barbora.Telegram.UserGenServer.reserve(chat_id, callback_id, {hour_id, day_id})
  end

  def match(msg) do
    Logger.info("bad match: #{inspect(msg)}")
  end

  def match_text("/start", chat_id) do
    Barbora.Telegram.User.send_message(chat_id, @greeting)
  end

  def match_text("/stop", chat_id) do
    Barbora.Telegram.UsersDynamicSupervisor.remove_user(chat_id)
    Logger.info("User unsubscribed: #{chat_id}")
    Barbora.Telegram.User.send_message(chat_id, "bye bye")
  end

  def match_text("/auth " <> text, chat_id) do
    with [email, password] <- String.split(text, " "),
         {:ok, _pid} <-
           Barbora.Telegram.UsersDynamicSupervisor.add_user({chat_id, {email, password}}) do
      Barbora.Telegram.User.send_message(chat_id, "Great! Ill keep you notified ;)")
      Logger.info("New user registered #{chat_id}, #{email}")
    else
      {:error, {:already_started, _pid}} ->
        Barbora.Telegram.User.send_message(chat_id, "You are already registered")

      err ->
        Logger.warn("Something went wrong while registering: #{inspect(err)}")

        Barbora.Telegram.User.send_message(
          chat_id,
          "Something wrong with your provided authorization"
        )
    end
  end

  def match_text(_text, chat_id) do
    Barbora.Telegram.User.send_message(chat_id, "Sorry, i don't understand what you mean")
  end
end
