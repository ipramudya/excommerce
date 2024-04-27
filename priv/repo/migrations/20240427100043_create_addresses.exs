defmodule ExcommerceApi.Repo.Migrations.CreateAddresses do
  use Ecto.Migration

  def change do
    create table(:addresses, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :full_line, :string
      add :city, :string
      add :province, :string
      add :postal_code, :string

      timestamps(inserted_at: :created_at)
    end

    create index(:addresses, [:city, :province, :full_line])

    alter table(:users) do
      add :address_id, references(:addresses, on_delete: :delete_all, type: :binary_id)
    end
  end
end
