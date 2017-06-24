use Mix.Config

config :logger, :console, format: "[$level] $message\n", level: :info

# Configure your database
config :telegram_bot, TelegramBot.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: 10

config :telegram_bot, port: System.get_env("PORT")
config :telegram_bot, webhook_path: System.get_env("WEBHOOK_PATH")
