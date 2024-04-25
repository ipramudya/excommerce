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

  @spec get_by_email(String.t()) :: Account.t() | nil
  def get_by_email(email) do
    query = from a in Account, where: a.email == ^email
    Repo.one(query) |> Repo.preload(:user)
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
