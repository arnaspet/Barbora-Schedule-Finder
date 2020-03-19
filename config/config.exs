import Config

config :barbora, Barbora.Scheduler,
  jobs: [
    {"* * * * *", {Barbora, :check_deliveries, []}}
  ]

config :barbora, :notifier, Barbora.Notifier.Slack

unless Mix.env() == :prod do
  import_config "config_secret.exs"
end
