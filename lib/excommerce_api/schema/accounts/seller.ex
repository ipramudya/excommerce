defmodule ExcommerceApi.Schema.Accounts.Seller do
  use Ecto.Schema
  import Ecto.Changeset
  alias ExcommerceApi.Schema.Shop
  alias ExcommerceApi.Schema.Accounts.Account

  @type t :: %__MODULE__{
          firstname: String.t(),
          lastname: String.t(),
          bio: String.t(),
          account_id: any()
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "sellers" do
    field :firstname, :string
    field :lastname, :string
    field :bio, :string

    has_many :shops, Shop, foreign_key: :id

    belongs_to(:accounts, Account,
      foreign_key: :account_id,
      type: :binary_id
    )

    timestamps(inserted_at: :created_at)
  end

  @doc false
  def changeset(seller, attrs) do
    seller
    |> cast(attrs, [:firstname, :lastname, :bio])
    |> foreign_key_constraint(:account_id)
    |> validate_required([:firstname, :lastname, :bio])
  end
end
