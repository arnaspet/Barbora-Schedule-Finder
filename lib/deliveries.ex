defmodule Barbora.Deliveries do
  def filter_available_deliveries(%{"deliveries" => [%{"params" => %{"matrix" => matrix}}]}) do
    Enum.flat_map(matrix, fn day -> filter_available_hours(day) end)
  end

  defp filter_available_hours(%{"hours" => hours}) do
    Enum.filter(hours, fn
      %{"available" => true} -> true
      _ -> false
    end)
  end
end
