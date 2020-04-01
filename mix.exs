defmodule Barbora.MixProject do
  use Mix.Project

  def project do
    [
      app: :barbora,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Barbora, []},
      extra_applications: [:logger, :nadia]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tesla, "~> 1.3"},
      {:jason, "~> 1.2"},
      {:nadia, "~> 0.6.0"},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/resources"]
  defp elixirc_paths(_), do: ["lib"]
end
