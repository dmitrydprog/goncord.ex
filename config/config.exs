# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :goncord,
  ecto_repos: [Goncord.Repo]

# Configures the endpoint
config :goncord, Goncord.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "y8r+oiKcrYSOl9vMjdiVnJ0pEVJlOEErH7e6u9PwcCbEdmRPxYzCNUANUS2nepMc",
  render_errors: [view: Goncord.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Goncord.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  issuer: "Goncord",
  secret_key: "LCJaAHj7bDOi66eBzBEPafhzgXJsdaiF9o6HeVHCjlYJNXJz5Z0X757DqQjkWGl8",
  serializer: Goncord.GuardianSerializer,
  hooks: GuardianDb

config :guardian_db, GuardianDb,
   repo: Goncord.Repo

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
