defmodule ExcommerceApi.Context.Products do
  import Ecto.Query, warn: false

  alias ExcommerceApi.Repo
  alias ExcommerceApi.Schema.Products.{Discount, Product}

  def get_products(shop_id) do
    from(product in Product,
      where: product.shop_id == ^shop_id,
      preload: :discount
    )
    |> Repo.all()
  end

  def get_product!(product_id) do
    Product
    |> Repo.get!(product_id)
    |> Repo.preload(:discount)
  end

  def create_product(shop_id, attrs) do
    {discount, product} = Map.pop(attrs, "discount")
    product_with_shop_id = Map.put_new(product, "shop_id", shop_id)

    product_created =
      %Product{}
      |> Repo.preload(:discount)
      |> Product.changeset(product_with_shop_id)
      |> Repo.insert()

    unless is_nil(discount) do
      product_created |> apply_discount_get_product(discount)
    else
      product_created
    end
  end

  defp apply_discount_get_product(product_changeset, discount) do
    {:ok, product_created} = product_changeset

    with {:ok, _res} <- put_discount_into_product(product_created, discount),
         %Product{} = product_with_discount <- get_product!(product_created.id) do
      {:ok, product_with_discount}
    else
      err when is_tuple(err) ->
        delete_product(product_created)
        err

      _ ->
        delete_product(product_created)
        {:error, "Something went wrong!"}
    end
  end

  def update_product(product_id, attrs \\ %{}) do
    with product <- get_product!(product_id) do
      product |> Product.changeset(attrs) |> Repo.update()
    end
  end

  def delete_product(product) do
    product |> Repo.delete()
  end

  def put_discount_into_product(product_changeset, discount) do
    product_changeset
    |> Ecto.build_assoc(:discount)
    |> Discount.changeset(discount)
    |> Repo.insert(returning: false)
  end

  def update_discount(discount_id, attrs \\ %{}) do
    with discount <- get_discount!(discount_id) do
      discount |> Discount.changeset(attrs) |> Repo.update()
    end
  end

  def revoke_discount(discount_id) do
    with discount <- get_discount!(discount_id) do
      discount |> Repo.delete()
    end
  end

  defp get_discount!(discount_id) do
    Discount |> Repo.get!(discount_id)
  end
end
