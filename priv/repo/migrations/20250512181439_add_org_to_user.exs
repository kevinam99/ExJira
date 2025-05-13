defmodule ExJira.Repo.Migrations.AddOrgToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :organisation_id, references(:organisations, type: :string)
      add :role, :string
    end

    create index(:users, [:organisation_id])
  end
end
