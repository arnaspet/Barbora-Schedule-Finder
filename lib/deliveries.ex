defmodule Barbora.Deliveries do
  def filter_available_deliveries(%{"deliveries" => [%{"params" => %{"matrix" => matrix}}]}) do
    Enum.flat_map(matrix, fn day -> filter_available_hours(day) end)
  end

  defp filter_available_hours(%{"hours" => hours, "id" => day_id}) do
    Enum.filter(hours, fn
      %{"available" => true} -> true
      _ -> false
    end)
    |> add_day_id(day_id)
  end

  defp add_day_id(hours, day_id) do
    Enum.map(hours, &Map.put_new(&1, "day_id", day_id))
  end
end
