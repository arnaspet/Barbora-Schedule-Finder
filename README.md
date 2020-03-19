# Barbora
Automatic checker for barbora timetables. Checks every minute for available timeslots.

## Installation

Just copy and paste this command, open `config/config_secret.exs` and fill with your secret
```bash
cat << EOF > config/config_secret.exs
import Config

config :barbora, Barbora.Client,
  email: "email@email.com",
  password: "password"

config :barbora, Barbora.Provider.Slack,
  hook_url: "slack_hook"
EOF

```

## Run
```
mix run --no-halt
```

## Notifiers
Currently there is only `Slack` notifier
