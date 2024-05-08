defmodule ExcommerceApi.Schema.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset
  alias ExcommerceApi.Schema.{Shop, Products.Discount}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "products" do
    field :name, :string
    field :description, :string
    field :price, :decimal
    field :stock, :integer
    field :sku_number, :string

    has_one :discount, Discount
    belongs_to(:shops, Shop, foreign_key: :shop_id, type: :binary_id)

    timestamps(inserted_at: :created_at)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :price, :stock, :sku_number, :shop_id])
    |> cast_assoc(:discount)
    |> validate_required([:name, :description, :price, :stock, :sku_number])
  end
end
