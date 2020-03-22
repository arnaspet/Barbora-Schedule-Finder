import Config

config :barbora, Barbora.LoginProvider.Config,
  email: System.fetch_env!("BARBORA_EMAIL"),
  password: System.fetch_env!("BARBORA_PASSWORD")

config :barbora, Barbora.Notifier.Slack,
  hook_url: System.fetch_env!("SLACK_HOOK_URL"),
  title: System.fetch_env!("SLACK_TITLE")
