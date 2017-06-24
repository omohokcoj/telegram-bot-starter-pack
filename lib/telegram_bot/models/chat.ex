defmodule TelegramBot.Models.Chat do
  use Ecto.Schema

  import Ecto.Changeset

  schema "chats" do
    field :external_id, :integer
    field :first_name,  :string
    field :type,        :string
    field :username,    :string

    has_many :messages, TelegramBot.Models.Message

    timestamps()
  end

  @attributes [:first_name, :username, :type]

  def changeset(message, params \\ %{}) do
    message
    |> cast(params, @attributes)
    |> put_change(:external_id, params["id"])
    |> validate_required([:external_id] ++ @attributes)
  end
end
