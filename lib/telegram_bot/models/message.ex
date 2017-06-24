defmodule TelegramBot.Models.Message do
  use Ecto.Schema

  import Ecto.Changeset

  alias TelegramBot.{Repo, Models}

  schema "messages" do
    field :external_id, :integer
    field :text,        :string
    field :date,        :utc_datetime
    field :captures,    :map, virtual: true, default: %{}

    belongs_to :chat, Models.Chat
    belongs_to :user, Models.User

    timestamps()
  end

  def changeset(message, params \\ %{}) do
    message
    |> cast(params, [:text])
    |> put_change(:external_id, params["message_id"])
    |> put_change(:date, DateTime.from_unix!(params["date"]))
    |> validate_required([:external_id, :date])
    |> assign_assoc(:user, using: :external_id, params: "from")
    |> assign_assoc(:chat, using: :external_id)
  end

  defp assign_assoc(changeset, name, opts \\ []) when is_atom(name) do
    params_key  = Keyword.get(opts, :params, Atom.to_string(name))
    using_field = Keyword.get(opts, :using, "id")

    module_name  = name |> Atom.to_string |> Macro.camelize
    assoc_module = changeset.data.__struct__ |> Module.split |> List.replace_at(-1, module_name) |> Module.concat

    case Map.get(changeset.params, params_key) do
      %{} = assoc_params ->
        assoc = Repo.get_by(assoc_module, [{using_field, assoc_params["id"]}])

        assoc_changeset = apply(assoc_module, :changeset, [assoc || struct(assoc_module), assoc_params])

        put_assoc(changeset, name, assoc_changeset)
      _ ->
        changeset
    end
  end
end
