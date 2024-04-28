defmodule ExcommerceApi.Accounts.Account do
  alias ExcommerceApi.Accounts.User
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          password: String.t(),
          email: String.t(),
          logout_at: String.t() | nil,
          role: String.t(),
          user: User.t() | nil
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :password, :string
    field :email, :string
    field :logout_at, :string
    field :role, :string

    has_one :user, User, defaults: nil

    timestamps(inserted_at: :created_at)
  end

  def changeset(account, attrs) do
    account
    |> cast(attrs, [:email, :password, :logout_at, :role])
    |> cast_assoc(:user)
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
end
