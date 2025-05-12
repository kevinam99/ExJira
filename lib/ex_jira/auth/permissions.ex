defmodule ExJira.Auth.Permissions do
  @roles %{
    "admin" => [:read, :create, :update, :delete],
    "manager" => [:read, :create, :update],
    "employee" => [:read]
  }

  def can?(%ExJira.Accounts.User{role: role}, action) do
    Enum.member?(@roles[role] || [], action)
  end
end
