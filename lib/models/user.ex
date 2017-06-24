defmodule TelegramBot.Models.User do
  use Ecto.Schema

  import Ecto.Changeset

  schema "users" do
    field :external_id,   :integer
    field :first_name,    :string
    field :username,      :string
    field :language_code, :string

    has_many :messages, TelegramBot.Models.Message

    timestamps()
  end

  @attributes [:first_name, :username, :language_code]

  def changeset(message, params \\ %{}) do
    message
    |> cast(params, @attributes)
    |> put_change(:external_id, params["id"])
    |> validate_required([:external_id] ++ @attributes)
  end
end
