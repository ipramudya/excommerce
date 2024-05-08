defmodule ExcommerceApi.Schema.Products.Discount do
  use Ecto.Schema
  import Ecto.Changeset
  alias ExcommerceApi.Schema.Products.Product

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "discounts" do
    field :until, :naive_datetime
    field :percentage, :integer

    belongs_to(:products, Product, foreign_key: :product_id, type: :binary_id)
    timestamps(inserted_at: :created_at)
  end

  @doc false
  def changeset(discount, attrs) do
    discount
    |> cast(attrs, [:percentage, :until])
    |> foreign_key_constraint(:product_id)
    |> validate_required([:percentage, :until])
    |> validate_number(:percentage, greater_than_or_equal_to: 0, less_than_or_equal_to: 100)
  end
end
