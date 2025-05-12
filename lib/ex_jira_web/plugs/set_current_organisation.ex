defmodule ExJiraWeb.Plugs.SetCurrentOrganisation do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _opts) do
    user = conn.assigns[:current_user]

    if user && user.organisation_id do
      conn
      |> assign(:current_organisation_id, user.organisation_id)
    else
      conn
    end
  end
end
