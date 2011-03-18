# Barbora

**TODO: Add description**

## Installation

Just copy and paste this command, open `config/config_secret.exs` and 
```bash
cat << EOF > config/config_secret.exs
import Config

config :barbora, Barbora.Client,
       email: "email@email.com",
       password: "secret123"

EOF

```
