defmodule ExcommerceApi.ProductsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExcommerceApi.Products` context.
  """

  @doc """
  Generate a discount.
  """
  def discount_fixture(attrs \\ %{}) do
    {:ok, discount} =
      attrs
      |> Enum.into(%{
        percentage: 42,
        until: ~N[2024-05-06 14:06:00]
      })

    # |> ExcommerceApi.Products.create_discount()

    discount
  end

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name",
        price: "120.5",
        sku_number: "some sku_number",
        stock: 42
      })

    # |> ExcommerceApi.Products.create_product()

    product
  end
end
