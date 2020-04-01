defmodule ResourcesHelper do
  def get_resource(filename) do
    "#{File.cwd!()}/test/resources/#{filename}"
    |> File.read!()
    |> Jason.decode!()
  end
end
