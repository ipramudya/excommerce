defmodule ExcommerceApiWeb.ShopController do
  use ExcommerceApiWeb, :controller

  alias ExcommerceApi.Context.Shops

  action_fallback ExcommerceApiWeb.FallbackController

  def index(conn, _params) do
    account = conn.assigns.current_account
    shops = Shops.list_shops(account.seller.id)

    render(conn, :index, shops: shops)
  end

  def show(conn, %{"id" => shop_id}) do
    shop = Shops.get_shop!(shop_id)
    render(conn, :show, shop: shop)
  end

  def create(conn, %{"shop" => shop_params, "address" => address_params}) do
    account = conn.assigns.current_account

    with {:ok, shop} <-
           Shops.create_shop(account.seller.id, %{shop: shop_params, address: address_params}) do
      render(conn, :show, shop: shop)
    end
  end

  def update(conn, %{"id" => shop_id, "shop" => shop_params}) do
    {address, shop} = Map.pop(shop_params, "address")

    with {:ok, shop} <- Shops.update_shop(shop_id, %{shop: shop, address: address}) do
      render(conn, :show, shop)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, message} <- Shops.delete_shop(id) do
      conn |> put_status(:accepted) |> json(%{message: message})
    end
  end
end
