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

  def get_shop!(shop_id) do
    from(shop in Shop,
      join: address in Address,
      on: shop.address_id == address.id,
      where: shop.id == ^shop_id,
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
      |> Shop.changeset(attrs.shop)
      |> Ecto.Changeset.change(%{address_id: address[:id], seller_id: seller_id})
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

  def update_shop(shop_id, attrs \\ %{}) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:shop, fn _params ->
      existing_shop = get_shop!(shop_id)

      changeset =
        existing_shop
        |> Map.from_struct()
        |> Map.update!(:name, &(Map.get(attrs.shop, "name") || &1))
        |> Map.update!(:bio, &(Map.get(attrs.shop, "bio") || &1))
        |> Map.update!(:contact, &(Map.get(attrs.shop, "contact") || &1))

      existing_shop |> Shop.changeset(changeset)
    end)
    |> Ecto.Multi.run(:address, fn repo, %{shop: shop} ->
      unless is_nil(attrs.address) do
        existing_address = Address |> repo.get!(shop.address_id)
        address_keys = attrs.address |> Map.keys()

        changeset =
          for key <- address_keys, into: %{} do
            unless is_nil(Map.get(attrs.address, key)) do
              {key, Map.get(attrs.address, key)}
            else
              {key, Map.get(existing_address, String.to_atom(key))}
            end
          end
          |> Map.take(["full_line", "city", "province", "postal_code"])

        existing_address
        |> Address.changeset(changeset)
        |> repo.update()
      else
        {:ok, nil}
      end
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{shop: shop, address: address}} -> {:ok, shop: Map.replace(shop, :address, address)}
      _ -> {:error, 400}
    end
  end
end
