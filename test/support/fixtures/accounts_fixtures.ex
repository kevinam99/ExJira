defmodule ExJira.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExJira.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hell0123"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password()
    })
  end

  @spec user_fixture(any()) :: any()
  def user_fixture(attrs \\ %{}) do
    organisation = ExJira.OrganisationsFixtures.organisation_fixture()

    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Map.put_new(:organisation_id, organisation.id)
      |> ExJira.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end
