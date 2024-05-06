defmodule ExcommerceApi.Context.Shops do
  import Ecto.Query, warn: false

  alias ExcommerceApi.Schema.{Address, Shop}
  alias ExcommerceApi.Repo

  def list_shops(seller_id) do
    from(shop in Shop,
      join: address in Address,
      on: shop.address_id == address.id,
      where: shop.seller_id == ^seller_id,
      preload: [:address, :seller]
    )
    |> Repo.all()
  end

  def get_shop!(seller_id, shop_id) do
    from(shop in Shop,
      join: address in Address,
      on: shop.address_id == address.id,
      where: shop.seller_id == ^seller_id and shop.id == ^shop_id,
      preload: [:address, :seller]
    )
    |> Repo.one!()
  end

  def create_shop(seller_id, attrs \\ %{}) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :address,
      Address.changeset(%Address{}, attrs[:address])
    )
    |> Ecto.Multi.insert(:shop, fn %{address: address} ->
      %Shop{}
      |> Shop.changeset(attrs[:shop])
      |> Ecto.Changeset.change(%{address_id: address.id, seller_id: seller_id})
    end)
    |> Ecto.Multi.run(:final, fn repo, %{address: address, shop: shop} ->
      val =
        shop
        |> repo.preload([:address, :seller])
        |> Map.from_struct()
        |> Map.replace!(:address, address)

      {:ok, val}
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{final: shop}} -> {:ok, shop}
      _ -> {:error, "Something went wrong!"}
    end
  end
end
