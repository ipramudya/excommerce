defmodule ExcommerceApiWeb.DiscountController do
  alias ExcommerceApi.Context.Products
  use ExcommerceApiWeb, :controller

  action_fallback ExcommerceApiWeb.FallbackController

  def create(conn, %{"product_id" => product_id, "discount" => discount_params}) do
    with product <- Products.get_product!(product_id),
         {:ok, discount} <- Products.put_discount_into_product(product, discount_params) do
      conn
      |> put_status(:created)
      |> json(%{
        discount: Map.take(discount, [:until, :id, :percentage])
      })
    end
  end

  def update(conn, %{"id" => id, "discount" => discount_params}) do
    with {:ok, discount} <- Products.update_discount(id, discount_params) do
      conn
      |> put_status(:accepted)
      |> json(%{
        discount: Map.take(discount, [:until, :id, :percentage])
      })
    end
  end

  def revoke(conn, %{"id" => id}) do
    with _discount <- Products.revoke_discount(id) do
      conn
      |> put_status(:accepted)
      |> json(%{data: %{status: "success"}})
    end
  end
end
