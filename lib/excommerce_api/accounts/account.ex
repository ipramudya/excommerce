defmodule ExcommerceApi.Accounts.Account do
  alias ExcommerceApi.Accounts.Seller
  alias ExcommerceApi.Accounts.User
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          password: String.t(),
          email: String.t(),
          role: String.t(),
          user: User.t() | nil,
          seller: Seller.t() | nil
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :password, :string
    field :email, :string
    field :role, :string

    has_one :user, User, defaults: nil
    has_one :seller, Seller, defaults: nil

    timestamps(inserted_at: :created_at)
  end

  def changeset(account, attrs) do
    account
    |> cast(attrs, [:email, :password, :role])
    |> cast_assoc(:user)
    |> cast_assoc(:seller)
    |> validate_required([:email, :password])
    |> unique_constraint(:email)
    |> hash_password()
  end

  def cast_update_seller_changeset(account, attrs) do
    account
    |> prepend_for_update(attrs)
    |> cast_assoc(:seller)
  end

  def cast_update_user_changeset(account, attrs) do
    account
    |> prepend_for_update(attrs)
    |> cast_assoc(:user)
  end

  def update_password_changeset(account, attrs) do
    account
    |> cast(attrs, [:password])
    |> hash_password()
  end

  def role_changeset(account, attrs) do
    account
    |> cast(attrs, [:role])
    |> validate_inclusion(:role, ["common", "admin"],
      message: "Invalid value. Should be either 'common' or 'admin'"
    )
  end

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: plain_password}} ->
        change(changeset, %{password: Bcrypt.hash_pwd_salt(plain_password)})

      _ ->
        changeset
    end
  end

  defp prepend_for_update(changeset, attrs) do
    changeset
    |> cast(attrs, [:email])
    |> unique_constraint(:email)
  end
end
