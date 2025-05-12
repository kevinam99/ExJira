defmodule ExJira.Repo do
  use Ecto.Repo,
    otp_app: :ex_jira,
    adapter: Ecto.Adapters.Postgres
end
