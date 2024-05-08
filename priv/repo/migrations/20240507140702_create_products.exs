defmodule ExcommerceApi.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :text
      add :price, :decimal
      add :stock, :integer
      add :sku_number, :string
      add :shop_id, references(:shops, on_delete: :delete_all, type: :binary_id)

      timestamps(inserted_at: :created_at)
    end

    create index(:products, [:shop_id])
  end
end
