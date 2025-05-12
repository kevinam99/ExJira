defmodule ExJira.OrganisationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExJira.Organisations` context.
  """

  @doc """
  Generate a organisation.
  """
  def organisation_fixture(attrs \\ %{}) do
    {:ok, organisation} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> ExJira.Organisations.create_organisation()

    organisation
  end
end
