defmodule ExcommerceApi.Accounts.Seller do
  use Ecto.Schema
  import Ecto.Changeset

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

    belongs_to(:accounts, ExcommerceApi.Accounts.Account,
      foreign_key: :account_id,
      type: :binary_id
    )

    timestamps(inserted_at: :created_at)
  end

  @doc false
  def changeset(seller, attrs) do
    seller
    |> cast(attrs, [:fistname, :lastname, :bio])
    |> foreign_key_constraint(:account_id)
    |> validate_required([:fistname, :lastname, :bio])
  end
end
