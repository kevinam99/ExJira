defmodule ExJiraWeb.Plugs.Authorize do
  import Plug.Conn
  alias ExJira.Auth.Permissions

  @spec init(any()) :: any()
  def init(action), do: action

  def call(conn, action) do
    user = conn.assigns[:current_user]

    if Permissions.can?(user, action) do
      conn
    else
      conn
      |> Phoenix.Controller.put_flash(:error, "Not authorized")
      |> Phoenix.Controller.redirect(to: "/")
      |> halt()
    end
  end
end
