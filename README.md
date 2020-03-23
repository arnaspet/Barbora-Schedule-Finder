# Barbora
Automatic ~~checker~~ telegram bot for barbora timetables. Checks every minute for available timeslots.

## Installation
```bash
mix deps.get
```
Just copy and paste this command, open `config/config_secret.exs` and fill with your secret
```bash
cat << EOF > config/config_secret.exs
import Config

config :nadia,
  token: "telegram_token"
EOF

```

## Run
```
mix run --no-halt
```

### Docker run
```bash
docker build -t barbora:latest .
docker run -e TELEGRAM_TOKEN=telegram_token barbora
```

## Notifiers
Currently there is only `Slack` notifier
