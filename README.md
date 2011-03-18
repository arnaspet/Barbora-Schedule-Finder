# Barbora
Automatic checker for barbora timetables

## Installation

Just copy and paste this command, open `config/config_secret.exs` and 
```bash
cat << EOF > config/config_secret.exs
import Config

config :barbora, Barbora.Client,
  email: "email@email.com",
  password: "password"

config :barbora, :provider, Barbora.Provider.Slack

config :barbora, Barbora.Provider.Slack,
  hook_url: "slack_hook"
EOF

```
