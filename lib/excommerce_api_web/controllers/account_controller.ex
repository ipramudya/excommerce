defmodule ExcommerceApiWeb.AccountController do
  use ExcommerceApiWeb, :controller

  alias ExcommerceApi.Accounts
  alias ExcommerceApi.Accounts.Account

  action_fallback ExcommerceApiWeb.FallbackController

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, _params) do
    accounts = Accounts.list_accounts()
    render(conn, :index, accounts: accounts)
  end

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)
    render(conn, :show, account: account)
  end

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"account" => account}) do
    with {:ok, %Account{} = account} <- Accounts.create_account(account) do
      render(conn, :show, account: account)
    end
  end

  @spec delete(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def delete(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)

    with {:ok, _transaction} <- Accounts.delete_account(account) do
      conn
      |> put_status(:accepted)
      |> json(%{data: %{status: "success"}})
    end
  end

  @spec change_role(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def change_role(conn, %{"id" => id, "role" => role}) do
    account = Accounts.get_account!(id)

    with {:ok, %Account{} = account} <- Accounts.change_role(account, %{role: role}) do
      render(conn, :show, account: account)
    end
  end
end
