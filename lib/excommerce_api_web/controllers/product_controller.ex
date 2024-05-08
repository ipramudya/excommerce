defmodule ExcommerceApiWeb.ProductController do
  alias ExcommerceApi.Context.Products
  use ExcommerceApiWeb, :controller

  action_fallback ExcommerceApiWeb.FallbackController

  def index(conn, %{"shop_id" => shop_id}) do
    products = Products.get_products(shop_id)
    render(conn, :index, products: products)
  end

  def show(conn, %{"id" => id}) do
    product = Products.get_product!(id)
    render(conn, :show, product: product)
  end

  def create(conn, %{"product" => product_params, "shop_id" => shop_id}) do
    with {:ok, product_created} <- Products.create_product(shop_id, product_params) do
      render(conn, :show, product: product_created)
    end
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    with {:ok, product} <- Products.update_product(id, product_params) do
      render(conn, :show, product: product)
    end
  end

  def delete(conn, %{"id" => id}) do
    with product <- Products.get_product!(id),
         {:ok, _product} <- Products.delete_product(product) do
      conn
      |> put_status(:accepted)
      |> json(%{data: %{status: "success"}})
    end
  end
end
