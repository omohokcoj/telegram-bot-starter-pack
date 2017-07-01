defmodule TelegramBot.Web do
  use Plug.Router
  use Plug.ErrorHandler

  alias TelegramBot.{Repo, Models, Utils, HelloWorldResponder}

  require Logger

  plug Plug.Logger

  plug Plug.Parsers, parsers: [:json], json_decoder: Poison

  plug :match
  plug :dispatch

  post TelegramBot.webhook_path do
    Logger.info("Params: #{inspect(conn.params)}")

    if conn.params["message"] do
      %Models.Message{}
      |> Models.Message.changeset(conn.params["message"])
      |> Repo.insert_or_update!
    end

    conn.params
    |> Utils.ensure_atoms_map
    |> List.wrap
    |> Nadia.Parser.parse_result("getUpdates")
    |> List.first
    |> HelloWorldResponder.process_update!

    send_resp(conn, 200, "")
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
