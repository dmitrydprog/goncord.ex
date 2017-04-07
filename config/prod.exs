use Mix.Config

config :goncord, Goncord.Endpoint,
  http: [port: {:system, "PORT"}]

config :logger, level: :info

# Configure your database
config :goncord, Goncord.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "goncord_ex",
  password: "oi4CheiD",
  database: "goncord",
  hostname: "postgres",
  pool_size: 10


import_config "prod.secret.exs"
