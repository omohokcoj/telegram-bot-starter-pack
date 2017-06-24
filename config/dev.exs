use Mix.Config

config :logger, :console, format: "[$level] $message\n" #, level: :info

# Configure your database
config :telegram_bot, TelegramBot.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "telegram_bot_dev",
  hostname: "localhost",
  pool_size: 10
