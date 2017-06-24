defmodule TelegramBot.Web do
  use Plug.Router
  use Plug.ErrorHandler

  alias TelegramBot.{Repo, Models}

  require Logger

  if Mix.env == :dev do
    plug Plug.Logger, log: :debug
  end

  plug Plug.Parsers, parsers: [:json], json_decoder: Poison

  plug :match
  plug :dispatch

  post TelegramBot.webhook_path do
    case conn.params do
      %{"message" => message_params} ->
        message   = Repo.get_by(Models.Message, external_id: message_params["message_id"])

        unless message do
          changeset = Models.Message.changeset(%Models.Message{}, message_params)
          message = message || Repo.insert!(changeset)
        end

        TelegramBot.HelloWorldResponder.process_message(message)

        send_resp(conn, 200, "")
      _ ->
        send_resp(conn, 400, "WHAT?")
    end
  end

  match _ do
    send_resp(conn, 200, "I'm a teapot")
  end

  def start_link do
    port = Application.get_env(:telegram_bot, :port, "4000")
    Plug.Adapters.Cowboy.http(__MODULE__, [], port: String.to_integer(port))
  end

  def handle_errors(conn, %{kind: kind, reason: reason, stack: stack}) do
    Logger.error(Exception.format(kind, reason, stack))
    send_resp(conn, conn.status, "Oooops, Something went wrong")
  end
end
