defmodule ExcommerceApi.Schema.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias ExcommerceApi.Schema.{Accounts.Account, Address}

  @type t :: %__MODULE__{
          firstname: String.t(),
          lastname: String.t(),
          account_id: any(),
          address_id: any()
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :firstname, :string
    field :lastname, :string

    belongs_to(:accounts, Account,
      foreign_key: :account_id,
      type: :binary_id
    )

    belongs_to(:address, Address)

    timestamps(inserted_at: :created_at)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:firstname, :lastname, :account_id, :address_id])
    |> foreign_key_constraint(:account_id)
    |> foreign_key_constraint(:address_id)
    |> validate_required([:firstname, :lastname])
  end
end
