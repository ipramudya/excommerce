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
    field :account_id, :binary_id

    belongs_to(:accounts, ExcommerceApi.Accounts.Account, type: :binary_id)
    timestamps(inserted_at: :created_at)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:firstname, :lastname])
    |> validate_required([:firstname, :lastname])
  end
end
