defmodule TelegramBot.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :external_id, :integer,      null: false
      add :chat_id,     :integer,      null: false
      add :user_id,     :integer
      add :text,        :text,         null: false
      add :date,        :utc_datetime, null: false

      timestamps()
    end

    create index(:messages, [:external_id], unique: true)
    create index(:messages, [:chat_id])
    create index(:messages, [:user_id])
    create index(:messages, [:date])
  end
end
