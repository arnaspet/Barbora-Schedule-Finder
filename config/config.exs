import Config

config :barbora, Barbora.Scheduler,
  jobs: [
    {"* * * * *", {Barbora, :check_deliveries, []}}
  ]

config :barbora, :notifier, Barbora.Notifier.Slack

import_config "config_secret.exs"
