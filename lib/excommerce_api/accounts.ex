defmodule ExcommerceApi.Accounts do
  import Ecto.Query, warn: false
  alias ExcommerceApi.Address
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
    Account
    |> Repo.get!(id)
    |> Repo.preload(:user)
  end

  @spec get_by_email(String.t()) :: Account.t() | nil
  def get_by_email(email) do
    from(a in Account, where: a.email == ^email)
    |> Repo.one()
    |> Repo.preload(:user)
  end

  @spec create_account(map()) :: {:ok, Account.t()} | {:error, Ecto.Changeset.t()}
  def create_account(attrs \\ %{}) do
    %Account{}
    |> Repo.preload(:user)
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  @spec delete_account(Account.t()) :: {:ok, any()} | {:error, any()} | Ecto.Multi.failure()
  def delete_account(%Account{} = account) do
    Ecto.Multi.new()
    |> Ecto.Multi.delete(:account, account)
    |> Ecto.Multi.delete(:address, fn %{account: account} ->
      %Address{id: account.user.address_id}
    end)
    |> Repo.transaction()
  end

  @spec change_role(Account.t(), map()) :: {:ok, Account.t()} | {:error, Ecto.Changeset.t()}
  def change_role(account, attrs \\ %{}) do
    account
    |> Account.role_changeset(attrs)
    |> Repo.update()
  end

  def change_password(account, attrs) do
    case Bcrypt.verify_pass(attrs.current_password, account.password) do
      true ->
        put_into_attrs = %{password: attrs.new_password}

        account
        |> Repo.preload(user: [:address])
        |> Account.update_password_changeset(put_into_attrs)
        |> Repo.update()

      false ->
        {:error, "Passwords are incorrect"}
    end
  end
end
