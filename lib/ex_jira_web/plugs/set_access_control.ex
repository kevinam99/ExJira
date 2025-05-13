defmodule ExJiraWeb.Plugs.SetAccessControl do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _opts) do
    user = conn.assigns[:current_user]
    org_id = get_session(conn, :organisation_id)

    %ExJira.Accounts.AccessControl{} =
      access_control =
      ExJira.Accounts.get_access_control_by(%{user_id: user.id, organisation_id: org_id})

    put_session(conn, :access_control_id, access_control.id)
  end
end
