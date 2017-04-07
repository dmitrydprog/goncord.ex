mix local.hex --force
mix ecto.create
mix ecto.migrate
yes | mix phoenix.server
