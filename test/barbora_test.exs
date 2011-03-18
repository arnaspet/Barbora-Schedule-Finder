defmodule BarboraTest do
  use ExUnit.Case
  doctest Barbora

  test "greets the world" do
    assert Barbora.hello() == :world
  end
end
