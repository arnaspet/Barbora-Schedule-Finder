import Config

config :nadia,
  token: System.fetch_env!("TELEGRAM_TOKEN")
