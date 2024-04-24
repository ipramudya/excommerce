defmodule ExcommerceApi.Repo.Migrations.AlterUser do
  use Ecto.Migration

  def change do
    drop constraint("users", "users_account_id_fkey")

    alter table(:users) do
      modify :account_id, references(:accounts, on_delete: :delete_all, type: :binary_id)
    end
  end
end
