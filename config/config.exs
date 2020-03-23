import Config

config :logger, level: :debug

config :logger,
       backends: [{LoggerFileBackend, :debug_log}, :console]

config :logger, :debug_log,
       path: File.cwd!() <> "/log/barbora/debug.log",
       level: :error

unless Mix.env() == :prod do
  import_config "config_secret.exs"
end
