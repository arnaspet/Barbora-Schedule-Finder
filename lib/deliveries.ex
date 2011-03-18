defmodule Barbora.Deliveries do
  def filter_available_deliveries(response) do
    deliveries = response.body["deliveries"] |> Enum.at(0)
    matrix = deliveries["params"]["matrix"]

    Enum.flat_map(matrix, fn day -> filter_available_hours(day) end)
  end

  def filter_available_hours(day) do
    Enum.reduce(day["hours"], [], fn
      day = %{"available" => true}, acc -> [day | acc]
      _, acc -> acc
    end)
  end
end
