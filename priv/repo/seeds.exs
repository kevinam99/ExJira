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
acme_org = Repo.insert!(%Organisation{name: "Acme Corp", id: "acme"})
globex_org = Repo.insert!(%Organisation{name: "Globex Inc", id: "globex"})

# --- Create Users ---

bob =
  Seeds.create_user(%{
    email: "bob@example.com",
    password: "password123"
  })

Repo.insert!(%ExJira.Accounts.AccessControl{
  role: "admin",
  user_id: bob.id,
  organisation_id: acme_org.id
})

alice =
  Seeds.create_user(%{
    email: "alice@example.com",
    password: "password123"
  })

Repo.insert!(%ExJira.Accounts.AccessControl{
  role: "manager",
  user_id: alice.id,
  organisation_id: acme_org.id
})

stanley =
  Seeds.create_user(%{
    email: "stanley@example.com",
    password: "password123"
  })

Repo.insert!(%ExJira.Accounts.AccessControl{
  role: "employee",
  user_id: stanley.id,
  organisation_id: acme_org.id
})

Repo.insert!(%ExJira.Accounts.AccessControl{
  role: "admin",
  user_id: alice.id,
  organisation_id: globex_org.id
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
