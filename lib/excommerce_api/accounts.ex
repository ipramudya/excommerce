defmodule ExcommerceApi.Accounts do
  import Ecto.Query, warn: false
  alias ExcommerceApi.Repo

  alias ExcommerceApi.Accounts.Account

  @spec list_accounts() :: [Account.t()]
  def list_accounts do
    query =
      from(a in Account,
        join: u in assoc(a, :user),
        # LATER: join: s in assoc(a, :seller),
        preload: :user
      )

    Repo.all(query)
  end

  @spec get_account!(binary()) :: Account.t()
  def get_account!(id), do: Repo.get!(Account, id)

  @spec delete_account(Account.t()) :: {:ok, Account.t()} | {:error, Ecto.Changeset.t()}
  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  # def update_account(%Account{} = account, attrs) do
  #   account
  #   |> Account.changeset(attrs)
  #   |> Repo.update()
  # end
end
