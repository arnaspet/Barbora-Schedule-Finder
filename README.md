# Barbora
Automatic ~~checker~~ telegram bot for barbora timetables. Checks every minute for available timeslots.

## Installation
Just copy and paste this command, open `config/config_secret.exs` and fill with your secret
```bash
cat << EOF > config/config_secret.exs
import Config

config :nadia,
  token: "telegram_token"
EOF

```

```bash
mix deps.get
```

## Run
```
mix run --no-halt
```

### Bot commands in telegram
```
/start # startup a bot
/auth login password # starts a user scraper
/stop # stops user scraper
```

### Docker run
```bash
docker build -t barbora:latest .
docker run -e TELEGRAM_TOKEN=telegram_token barbora
```
