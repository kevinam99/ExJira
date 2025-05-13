defmodule ExJira.TasksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExJira.Tasks` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    organisation = ExJira.OrganisationsFixtures.organisation_fixture()

    {:ok, task} =
      attrs
      |> Map.put_new(:organisation_id, organisation.id)
      |> Enum.into(%{
        description: "some description",
        status: "some status",
        title: "some title"
      })
      |> ExJira.Tasks.create_task()

    task
  end
end
