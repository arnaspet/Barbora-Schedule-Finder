defmodule Barbora.MixProject do
  use Mix.Project

  def project do
    [
      app: :barbora,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Barbora, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tesla, "~> 1.3"},
      {:jason, "~> 1.2"},
      {:quantum, "~> 2.4"},
      {:timex, "~> 3.0"}
    ]
  end
end
