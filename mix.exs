defmodule TelegramBot.Mixfile do
  use Mix.Project

  def project do
    [app: :telegram_bot,
     version: "0.2.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     aliases: aliases()]
  end

  def application do
    [extra_applications: [:logger, :poolboy],
     mod: {TelegramBot, []}]
  end

  defp deps do
    [{:cowboy, "~> 1.0.0"},
     {:postgrex, ">= 0.0.0"},
     {:ecto, "~> 2.1"},
     {:plug, "~> 1.0"},
     {:httpoison, "~> 0.10.0"},
     {:poison, "~> 3.0"},
     {:nadia, "~> 0.4.2"},
     {:credo, "~> 0.5", only: :dev}]
  end

  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"],
     "server": ["run --no-halt"],
     "set_webhook": ["run -e 'TelegramBot.set_webhook'"]]
  end
end
