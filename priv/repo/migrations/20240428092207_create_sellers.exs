defmodule ExcommerceApi.Repo.Migrations.CreateSellers do
  use Ecto.Migration

  def change do
    create table(:sellers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :firstname, :string
      add :lastname, :string
      add :bio, :string
      add :account_id, references(:accounts, on_delete: :nothing, type: :binary_id)

      timestamps(inserted_at: :created_at)
    end

    create index(:sellers, [:account_id])
  end
end
