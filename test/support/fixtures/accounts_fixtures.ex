defmodule ExcommerceApi.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExcommerceApi.Accounts` context.
  """

  @doc """
  Generate a account.
  """
  def account_fixture(attrs \\ %{}) do
    {:ok, account} =
      attrs
      |> Enum.into(%{
        email: "some email",
        password: "some password"
      })

    # |> ExcommerceApi.Accounts.create_account()

    account
  end
end
