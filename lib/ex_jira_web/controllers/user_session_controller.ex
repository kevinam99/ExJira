defmodule ExJiraWeb.UserSessionController do
  use ExJiraWeb, :controller

  alias ExJira.Accounts
  alias ExJiraWeb.UserAuth

  def create(conn, %{"_action" => "registered"} = params) do
    create(conn, params, "Account created successfully!")
  end

  def create(conn, %{"_action" => "password_updated"} = params) do
    conn
    |> put_session(:user_return_to, ~p"/users/settings")
    |> create(params, "Password updated successfully!")
  end

  def create(conn, params) do
    create(conn, params, "Welcome back!")
  end

  defp create(conn, %{"user" => user_params}, info) do
    %{"email" => email, "password" => password, "organisation_id" => org_id} = user_params

    with %ExJira.Accounts.User{} = user <-
           Accounts.get_user_by_email_and_password(email, password),
         %ExJira.Accounts.AccessControl{id: access_control_id} <-
           Accounts.get_access_control_by(%{user_id: user.id, organisation_id: org_id}) do
      conn
      |> put_flash(:info, info)
      |> UserAuth.log_in_user(user, Map.put(user_params, "access_control_id", access_control_id))
    else
      nil ->
        # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
        conn
        |> put_flash(:error, "Invalid email or password or organisation ID.")
        |> put_flash(:email, String.slice(email, 0, 160))
        |> redirect(to: ~p"/users/log_in")

      _ ->
        conn
        |> put_flash(:error, "You are not authorized to log in.")
        |> redirect(to: ~p"/users/log_in")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
