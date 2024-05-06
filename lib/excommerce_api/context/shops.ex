defmodule ExcommerceApi.Context.Shops do
  import Ecto.Query, warn: false

  alias ExcommerceApi.Schema.{Address, Shop}
  alias ExcommerceApi.Repo

  def list_shops(seller_id) do
    from(shop in Shop,
      join: address in Address,
      on: shop.address_id == address.id,
      where: shop.seller_id == ^seller_id,
      preload: [:address, :shop]
    )
    |> Repo.all()
  end

  def get_shop!(seller_id, shop_id) do
    from(shop in Shop,
      join: address in Address,
      on: shop.address_id == address.id,
      where: shop.seller_id == ^seller_id and shop.id == ^shop_id,
      preload: [:address, :shop]
    )
  end

  def create_shop(seller_id, attrs \\ %{}) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :address,
      Address.changeset(%Address{}, attrs["address"])
    )
    |> Ecto.Multi.insert(:shop, fn %{address: address} ->
      %Shop{}
      |> Shop.changeset(attrs["shop"])
      |> Ecto.Changeset.change(%{address_id: address.id, seller_id: seller_id})
    end)
    |> Repo.transaction()
  end

  @doc """
  Updates a shop.

  ## Examples

      iex> update_shop(shop, %{field: new_value})
      {:ok, %Shop{}}

      iex> update_shop(shop, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_shop(%Shop{} = shop, attrs) do
    shop
    |> Shop.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a shop.

  ## Examples

      iex> delete_shop(shop)
      {:ok, %Shop{}}

      iex> delete_shop(shop)
      {:error, %Ecto.Changeset{}}

  """
  def delete_shop(%Shop{} = shop) do
    Repo.delete(shop)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking shop changes.

  ## Examples

      iex> change_shop(shop)
      %Ecto.Changeset{data: %Shop{}}

  """
  def change_shop(%Shop{} = shop, attrs \\ %{}) do
    Shop.changeset(shop, attrs)
  end
end
