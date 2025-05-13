defmodule ExJira.Auth.Permissions do
  alias ExJira.Accounts.AccessControl
  alias ExJira.Accounts.User

  @roles %{
    "admin" => [:read, :create, :update, :delete],
    "manager" => [:read, :create, :update],
    "employee" => [:read]
  }

  def can?(%AccessControl{role: role, user_id: user_id}, %User{id: user_id}, action) do
    Enum.member?(@roles[role] || [], action)
  end
end
