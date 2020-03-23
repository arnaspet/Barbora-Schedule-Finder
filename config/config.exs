import Config

config :logger, level: :debug

unless Mix.env() == :prod do
  import_config "config_secret.exs"
end
