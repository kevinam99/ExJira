# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ExJira.Repo.insert!(%ExJira.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias ExJira.Repo
alias ExJira.Organisations.Organisation
alias ExJira.Tasks.Task

defmodule Seeds do
  def create_user(attrs) do
    {:ok, user} =
      %{}
      |> Map.merge(attrs)
      |> ExJira.Accounts.register_user()

    user
  end
end

# --- Create Organisations ---
acme_org = Repo.insert!(%Organisation{name: "Acme Corp"})
globex_org = Repo.insert!(%Organisation{name: "Globex Inc"})

# --- Create Users ---

acme_admin =
  Seeds.create_user(%{
    email: "admin@acme.com",
    password: "password123",
    organisation_id: acme_org.id,
    role: "admin"
  })

acme_manager =
  Seeds.create_user(%{
    email: "manager@acme.com",
    password: "password123",
    organisation_id: acme_org.id,
    role: "manager"
  })

acme_employee =
  Seeds.create_user(%{
    email: "employee@acme.com",
    password: "password123",
    organisation_id: acme_org.id,
    role: "employee"
  })

globex_admin =
  Seeds.create_user(%{
    email: "admin@globex.com",
    password: "password123",
    organisation_id: globex_org.id,
    role: "admin"
  })

# --- Create Tasks ---
Repo.insert!(%Task{
  title: "Set up project",
  description: "Initial setup for Acme's project",
  status: "open",
  organisation_id: acme_org.id
})

Repo.insert!(%Task{
  title: "Create roadmap",
  description: "Globex Q3 planning",
  status: "in_progress",
  organisation_id: globex_org.id
})
