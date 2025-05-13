defmodule ExJira.Organisations.Organisation do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}
  schema "organisations" do
    field :name, :string
    many_to_many :access_controls, ExJira.Accounts.AccessControl, join_through: "access_controls"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(organisation, attrs) do
    organisation
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
