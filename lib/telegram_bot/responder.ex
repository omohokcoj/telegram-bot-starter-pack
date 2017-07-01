defmodule TelegramBot.Responder do
  alias TelegramBot.Utils

  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
      import Nadia

      @before_compile unquote(__MODULE__)

      @patterns []
    end
  end

  defmacro __before_compile__(_) do
    quote do
      def process_update!(update) do
        Enum.take_while __MODULE__.defined_patterns, fn {type, pattern} ->
          matching =
            cond do
              is_bitstring(pattern) -> update.message.text == pattern
              is_list(pattern)      -> Enum.member?(pattern, update.message.text)
              %Regex{} = pattern    -> Regex.named_captures(pattern, update.message.text || "")
              true                  -> nil
            end

          if matching do
            apply(__MODULE__, :on, [:message, pattern, update.message, Utils.ensure_atoms_map(matching)])
          end

          !matching
        end
      end

      def defined_patterns, do: @patterns
    end
  end

  defmacro on_message(pattern, do: block) do
    quote do
      @patterns @patterns ++ [{:message, unquote(pattern)}]
      def on(:message, unquote(pattern), var!(message), var!(captures)), do: unquote(block)
    end
  end

  defmacro send_message(text, options \\ []) do
    quote do
      Nadia.send_message(var!(message).chat.id, unquote(text), unquote(options))
    end
  end
end
