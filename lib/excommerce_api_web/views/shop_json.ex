defmodule ExcommerceApiWeb.ShopJSON do
  def index(%{shops: shops}) do
    %{shops: for(shop <- shops, do: remap_data(shop))}
  end

  def show(%{shop: shop}) do
    %{shop: remap_data(shop)}
  end

  defp remap_data(data) do
    %{
      id: data.id,
      name: data.name,
      bio: data.bio,
      contact: data.contact,
      address: Map.take(data.address, [:id, :full_line, :city, :province, :postal_code]),
      seller: Map.take(data.seller, [:firstname, :lastname, :bio])
    }
  end
end
