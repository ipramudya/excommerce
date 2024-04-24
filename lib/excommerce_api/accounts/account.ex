defmodule ExcommerceApi.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          password: String.t(),
          email: String.t(),
          logout_at: String.t() | nil
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :password, :string
    field :email, :string
    field :logout_at, :string

    timestamps(inserted_at: :created_at)
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:email, :password, :logout_at])
    |> validate_required([:email, :password])
    |> unique_constraint(:email)
  end
end
