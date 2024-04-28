defmodule ExcommerceApi.Repo.Migrations.RemoveLogoutAt do
  use Ecto.Migration

  def change do
    alter table(:accounts) do
      remove :logout_at
    end
  end
end
