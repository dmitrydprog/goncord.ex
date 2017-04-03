use Mix.Config

config :goncord, Goncord.Endpoint,
  http: [port: {:system, "PORT"}]

config :logger, level: :info

import_config "prod.secret.exs"
