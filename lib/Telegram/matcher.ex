defmodule Barbora.Telegram.Matcher do
  require Logger

  @greeting """
  Please provider email and password to barbora website in format like so:
    /auth myemail@email.com password
  """

  def match(
        %Nadia.Model.Update{
          message: %Nadia.Model.Message{text: "/start", chat: %Nadia.Model.Chat{id: chat_id}}
        } = update
      ) do
    Nadia.send_message(chat_id, @greeting)
  end

  def match(
        %Nadia.Model.Update{
          message: %Nadia.Model.Message{
            text: "/auth " <> text,
            chat: %Nadia.Model.Chat{id: chat_id}
          }
        } = update
      ) do
    Logger.debug("matched /auth")

    with [email, password] <- String.split(text, " "),
         {:ok, pid} <- Barbora.Telegram.add_user({chat_id, {email, password}}) do
      Logger.info("New user registered #{chat_id}, #{email}")
    else
      err ->
        Logger.info("Something went wrong while registering: #{IO.inspect(err)}")
        Nadia.send_message(chat_id, "Something wrong with your provided authorization")
    end
  end

  def match(%Nadia.Model.Update{
        message: %Nadia.Model.Message{chat: %Nadia.Model.Chat{id: chat_id}}
      }) do
    Nadia.send_message(chat_id, "Sorry, i don't understand what you mean")
  end
end
