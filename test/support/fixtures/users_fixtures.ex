defmodule ExcommerceApi.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExcommerceApi.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        firstname: "some firstname",
        lastname: "some lastname"
      })

    # |> ExcommerceApi.Users.create_user()

    user
  end
end
