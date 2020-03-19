defmodule Barbora.Notifier.Slack do
  @hook_url Application.fetch_env!(:barbora, Barbora.Notifier.Slack)[:hook_url]
  @predefined_blocks [
    %{
      type: "section",
      text: %{
        type: "plain_text",
        text: "Atsirado barboros pristatymas!"
      }
    },
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
    blocks = @predefined_blocks ++ (available_timeslots |> format_delivery_times)

    Tesla.client([Tesla.Middleware.JSON])
    |> Tesla.post!(@hook_url, %{blocks: blocks})
  end

  defp format_delivery_times(available_timeslots) do
    available_timeslots
    |> Enum.reduce([], fn
      slot, acc ->
        [%{type: "section", text: %{type: "mrkdwn", text: "`#{slot["deliveryTime"]}`"}} | acc]
    end)
  end
end
