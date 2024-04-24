defmodule ExcommerceApi.Accounts do
  import Ecto.Query, warn: false
  alias ExcommerceApi.Repo

  alias ExcommerceApi.Accounts.Account

  @spec list_accounts() :: [Account.t()]
  def list_accounts do
    Account
    |> Repo.all()
    |> Repo.preload(:user)
  end

  @spec get_account!(binary()) :: Account.t()
  def get_account!(id) do
    Repo.get!(Account, id) |> Repo.preload(:user)
  end

  @spec delete_account(Account.t()) :: {:ok, Account.t()} | {:error, Ecto.Changeset.t()}
  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end
end
