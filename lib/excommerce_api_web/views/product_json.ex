defmodule ExcommerceApiWeb.ProductJSON do
  def index(%{products: products}) do
    %{products: for(product <- products, do: remap_data(product))}
  end

  def show(%{product: product}) do
    %{
      product: remap_data(product)
    }
  end

  defp remap_data(data) do
    %{
      id: data.id,
      name: data.name,
      description: data.description,
      price: data.price,
      stock: data.stock,
      sku_number: data.sku_number,
      discount:
        case data.discount do
          nil -> nil
          _ -> Map.take(data.discount, [:id, :until, :percentage])
        end
    }
  end
end
