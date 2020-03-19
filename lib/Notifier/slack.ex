defmodule Barbora.Notifier.Slack do
  @predefined_blocks [
    %{type: "divider"},
    %{
      type: "section",
      text: %{
        type: "mrkdwn",
        text: "*Pristatymo laikai:*"
      }
    }
  ]

  def provide([]), do: :no_timeslots

  def provide(available_timeslots) do
    blocks = [get_title_block() | @predefined_blocks] ++ (available_timeslots |> format_delivery_times)

    Tesla.client([Tesla.Middleware.JSON])
    |> Tesla.post!(hook_url(), %{blocks: blocks})
  end

  def get_title_block() do
    %{
      type: "section",
      text: %{
        type: "plain_text",
        text: Application.fetch_env!(:barbora, Barbora.Notifier.Slack)[:title]
      }
    }
  end

  defp format_delivery_times(available_timeslots) do
    available_timeslots
    |> Enum.reduce([], fn
      slot, acc ->
        [%{type: "section", text: %{type: "mrkdwn", text: "`#{slot["deliveryTime"]}`"}} | acc]
    end)
  end

  defp hook_url(), do: Application.fetch_env!(:barbora, Barbora.Notifier.Slack)[:hook_url]
end
