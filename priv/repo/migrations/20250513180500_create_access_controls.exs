defmodule ExJira.Repo.Migrations.CreateAccessControls do
  use Ecto.Migration

  def change do
    create table(:access_controls) do
      add :role, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :organisation_id, references(:organisations, type: :string, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    alter table(:users) do
      remove :organisation_id
      remove :role
    end

    create index(:access_controls, [:user_id])
    create index(:access_controls, [:organisation_id])
  end
end
