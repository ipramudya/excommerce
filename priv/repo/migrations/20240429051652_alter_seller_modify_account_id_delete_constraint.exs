defmodule ExcommerceApi.Repo.Migrations.AlterSellerModifyAccountIdDeleteConstraint do
  use Ecto.Migration

  def change do
    drop constraint("sellers", "sellers_account_id_fkey")

    alter table(:sellers) do
      modify :account_id, references(:accounts, on_delete: :delete_all, type: :binary_id)
    end
  end
end
