defmodule ExcommerceApi.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          firstname: String.t(),
          lastname: String.t(),
          account_id: any()
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :firstname, :string
    field :lastname, :string

    belongs_to(:accounts, ExcommerceApi.Accounts.Account,
      foreign_key: :account_id,
      type: :binary_id
    )

    timestamps(inserted_at: :created_at)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:firstname, :lastname])
    |> foreign_key_constraint(:account_id)
    |> validate_required([:firstname, :lastname])
  end
end
