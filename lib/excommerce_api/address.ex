defmodule ExcommerceApi.Address do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "addresses" do
    field :full_line, :string
    field :city, :string
    field :province, :string
    field :postal_code, :string

    has_one :user, ExcommerceApi.Accounts.User, defaults: nil

    timestamps(inserted_at: :created_at)
  end

  def changeset(address, attrs) do
    address
    |> cast(attrs, [:full_line, :city, :province, :postal_code])
    |> cast_assoc(:user)
    |> validate_required([:full_line, :city, :province])
  end
end
