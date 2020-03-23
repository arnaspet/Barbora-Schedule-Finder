import Config

unless Mix.env() == :prod do
  import_config "config_secret.exs"
end
