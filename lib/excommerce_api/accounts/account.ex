defmodule ExcommerceApi.Accounts.Account do
  alias ExcommerceApi.Users.User
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          password: String.t(),
          email: String.t(),
          logout_at: String.t() | nil,
          user: User.t() | nil
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :password, :string
    field :email, :string
    field :logout_at, :string

    has_one :user, User

    timestamps(inserted_at: :created_at)
  end

  def changeset(account, attrs) do
    account
    |> cast(attrs, [:email, :password, :logout_at])
    |> validate_required([:email, :password])
    |> unique_constraint(:email)
    |> hash_password()
  end

  def update_changeset(account, attrs) do
    account
    |> cast(attrs, [:email])
    |> cast_assoc(:user)
    |> unique_constraint(:email)
  end

  defp hash_password(
         %Ecto.Changeset{
           valid?: true,
           changes: %{password: unhashed_password}
         } = changeset
       ) do
    change(changeset, %{password: Bcrypt.hash_pwd_salt(unhashed_password)})
  end

  defp hash_password(changeset), do: changeset
end
