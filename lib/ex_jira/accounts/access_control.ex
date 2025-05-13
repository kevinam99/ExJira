defmodule ExJira.Accounts.AccessControl do
  use Ecto.Schema
  import Ecto.Changeset

  @roles ["admin", "manager", "employess"]

  schema "access_controls" do
    field :role, :string

    belongs_to :user, ExJira.Accounts.User
    belongs_to :organisation, ExJira.Organisations.Organisation, type: :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(access_control, attrs) do
    access_control
    |> cast(attrs, [:role, :user_id, :organisation_id])
    |> validate_required([:role, :user_id, :organisation_id])
    |> validate_inclusion(:role, @roles)
  end
end
