defmodule TelegramBot.Repo.Migrations.CreateChats do
  use Ecto.Migration

  def change do
    create table(:chats) do
      add :external_id,   :integer, null: false
      add :first_name,    :text,    null: false
      add :type,          :text,    null: false
      add :username,      :text,    null: false

      timestamps()
    end

    create index(:chats, [:external_id], unique: true)
  end
end
