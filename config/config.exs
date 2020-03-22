import Config

config :barbora, Barbora.Scheduler,
  jobs: [
    {"* * * * *", {Barbora, :check_deliveries, []}}
  ]

config :barbora, :notifier, Barbora.Notifier.Slack
config :barbora, :login_provider, Barbora.LoginProvider.Config

unless Mix.env() == :prod do
  import_config "config_secret.exs"
end
