defmodule TelegramBot.Responder do
  @max_restarts 10
  @max_seconds 10

  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)

      @before_compile unquote(__MODULE__)

      @patterns []
    end
  end

  defmacro __before_compile__(_) do
    quote do
      def process_message(message) do
        Enum.each __MODULE__.defined_patterns, fn pattern ->
          matching =
            case pattern do
              p when is_bitstring(p) -> message.text == p
              %Regex{}               -> Regex.named_captures(pattern, message.text)
              _                      -> false
            end

          if matching do
            if is_map(matching) do
              matching = Enum.into(matching, %{}, fn {k, v} -> {String.to_atom(k), v} end)
              message  = Map.put(message, :captures, matching)
            end

            Task.Supervisor.start_child(unquote(__MODULE__), __MODULE__, :on, [pattern, message])
          end
        end
      end

      def defined_patterns, do: @patterns
    end
  end

  defmacro on(pattern, do: body) do
    quote do
      @patterns @patterns ++ [unquote(pattern)]
      def on(unquote(pattern), var!(message)), do: unquote(body)
    end
  end

  def send_resp(message, text, options \\ []) do
    Nadia.send_message(message.chat.external_id, text, options)
  end

  def start_link do
    Task.Supervisor.start_link(restart: :transient, max_restarts: @max_restarts,
                               max_seconds: @max_seconds, name: __MODULE__)
  end
end
