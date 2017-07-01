defmodule TelegramBot.Utils do
  def ensure_atoms_map([]), do: []
  def ensure_atoms_map(%{__struct__: _} = value), do: value
  def ensure_atoms_map(value) do
    if is_map(value) || Keyword.keyword?(value) do
      Enum.into value, %{}, fn ({k, v}) ->
        {ensure_atom(k), ensure_atoms_map(v)}
      end
    else
      value
    end
  end

  def ensure_atom(value) when is_bitstring(value), do: String.to_atom(value)
  def ensure_atom(value) when is_atom(value), do: value
end
