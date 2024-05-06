defmodule ExcommerceApi.Schema.Shop do
  use Ecto.Schema
  import Ecto.Changeset
  alias ExcommerceApi.Schema.{Accounts.Seller, Address}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "shops" do
    field :name, :string
    field :bio, :string
    field :contact, :string

    field :address_id, :binary_id
    has_one :address, Address, foreign_key: :id, references: :address_id

    belongs_to(:seller, Seller, foreign_key: :seller_id, type: :binary_id)
    timestamps(inserted_at: :created_at)
  end

  @doc false
  def changeset(shop, attrs) do
    shop
    |> cast(attrs, [:name, :bio, :contact])
    |> validate_required([:name, :bio, :contact])
  end
end
