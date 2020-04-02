defmodule Barbora.DeliveriesTest do
  use ExUnit.Case

  @empty_deliveries ResourcesHelper.get_resource("empty_deliveries.json")
  @few_deliveries ResourcesHelper.get_resource("few_deliveries.json")

  test "filters empty deliveries" do
    assert Barbora.Deliveries.filter_available_deliveries(@empty_deliveries) == []
  end

  test "filters few deliveries" do
    assert Barbora.Deliveries.filter_available_deliveries(@few_deliveries) |> Enum.count() == 2
  end

  test "deliveries has deliveryTime key" do
    for delivery <- Barbora.Deliveries.filter_available_deliveries(@few_deliveries) do
      assert %{"deliveryTime" => _deliveryTime} = delivery
    end
  end
end
