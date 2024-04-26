defmodule ExcommerceApi.Repo.Migrations.AlterAccountRole do
  use Ecto.Migration

  def change do
    alter table(:accounts) do
      add :role, :string, default: "common"
    end
  end
end
