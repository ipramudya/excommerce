defmodule ExcommerceApi.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :firstname, :string
      add :lastname, :string
      add :account_id, references(:accounts, on_delete: :nothing, type: :binary_id)

      timestamps(inserted_at: :created_at)
    end

    create index(:users, [:account_id])
  end
end
