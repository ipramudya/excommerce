defmodule ExcommerceApi.Repo.Migrations.CreateDiscounts do
  use Ecto.Migration

  def change do
    create table(:discounts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :percentage, :integer
      add :until, :naive_datetime
      add :product_id, references(:products, on_delete: :delete_all, type: :binary_id)

      timestamps(inserted_at: :created_at)
    end

    create index(:discounts, [:product_id])
  end
end
