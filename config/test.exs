use Mix.Config

# Configure your database
config :telegram_bot, TelegramBot.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "telegram_bot_test",
  hostname: "localhost",
  pool_size: 10
