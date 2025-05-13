defmodule ExJira.Repo.Migrations.CreateOrganisations do
  use Ecto.Migration

  def change do
    create table(:organisations, primary_key: false) do
      add :id, :string, null: false, primary_key: true
      add :name, :string

      timestamps(type: :utc_datetime)
    end
  end
end
