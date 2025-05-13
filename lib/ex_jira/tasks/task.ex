defmodule ExJira.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :status, :string
    field :description, :string
    field :title, :string
    belongs_to :organisation, ExJira.Organisations.Organisation, type: :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :description, :status, :organisation_id])
    |> validate_required([:title, :description, :status, :organisation_id])
  end
end
