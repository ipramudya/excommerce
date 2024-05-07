defmodule ExcommerceApi.ShopsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExcommerceApi.Shops` context.
  """

  @doc """
  Generate a shop.
  """
  def shop_fixture(attrs \\ %{}) do
    {:ok, shop} =
      attrs
      |> Enum.into(%{
        bio: "some bio",
        contact: "some contact",
        name: "some name"
      })

    # |> ExcommerceApi.Shops.create_shop()

    shop
  end
end
