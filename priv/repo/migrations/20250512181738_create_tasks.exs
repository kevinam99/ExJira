defmodule ExJira.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string
      add :description, :text
      add :status, :string
      add :organisation_id, references(:organisations, type: :string, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:tasks, [:organisation_id])
  end
end
