defmodule ExcommerceApi.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :string
      add :password, :string
      add :logout_at, :string

      timestamps(inserted_at: :created_at)
    end

    create unique_index(:accounts, :email)
  end
end
