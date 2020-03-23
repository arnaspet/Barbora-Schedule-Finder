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
      extra_applications: [:logger, :nadia, :logger_file_backend]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tesla, "~> 1.3"},
      {:jason, "~> 1.2"},
      {:nadia, "~> 0.6.0"},
      {:logger_file_backend, "~> 0.0.10"},
    ]
  end
end
