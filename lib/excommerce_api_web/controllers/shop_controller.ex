defmodule ExcommerceApiWeb.ShopController do
  use ExcommerceApiWeb, :controller

  alias ExcommerceApi.Context.Shops

  action_fallback ExcommerceApiWeb.FallbackController

  def index(conn, _params) do
    account = conn.assigns.current_account
    shops = Shops.list_shops(account.seller.id)

    render(conn, :index, shops: shops)
  end

  def create(conn, %{"shop" => shop_params, "address" => address_params}) do
    account = conn.assigns.current_account

    with {:ok, shop} <-
           Shops.create_shop(account.seller.id, %{shop: shop_params, address: address_params}) do
      render(conn, :show, shop: shop)
    end
  end

  def show(conn, %{"id" => shop_id}) do
    account = conn.assigns.current_account

    shop = Shops.get_shop!(account.seller.id, shop_id)
    render(conn, :show, shop: shop)
  end
end
