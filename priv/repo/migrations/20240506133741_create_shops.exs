defmodule ExcommerceApi.Repo.Migrations.CreateShops do
  use Ecto.Migration

  def change do
    create table(:shops, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :bio, :text
      add :contact, :string
      add :seller_id, references(:sellers, on_delete: :delete_all, type: :binary_id)
      add :address_id, references(:addresses, on_delete: :delete_all, type: :binary_id)

      timestamps(inserted_at: :created_at)
    end

    create index(:shops, [:seller_id, :address_id])
  end
end
