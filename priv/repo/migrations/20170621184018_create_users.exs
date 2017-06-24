defmodule TelegramBot.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :external_id,   :integer, null: false
      add :first_name,    :text,    null: false
      add :language_code, :text,    null: false
      add :username,      :text,    null: false

      timestamps()
    end

    create index(:users, [:external_id], unique: true)
  end
end
