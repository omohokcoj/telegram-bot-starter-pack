defmodule TelegramBot do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(TelegramBot.Web, []),
      supervisor(TelegramBot.Repo, []),
      supervisor(TelegramBot.Responder, [])
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end

  def webhook_path do
    Application.get_env(:telegram_bot, :webhook_path, "/")
  end

  def webhook_url do
    "https://#{System.get_env("HOST")}/#{webhook_path}"
  end

  def set_webhook do
    [url: webhook_url] |> Nadia.set_webhook |> inspect |> IO.puts
  end
end
