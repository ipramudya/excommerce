defmodule ExcommerceApiWeb.UserController do
  use ExcommerceApiWeb, :controller

  alias ExcommerceApi.{Accounts, Accounts.Account, Users, Accounts.User}

  action_fallback ExcommerceApiWeb.FallbackController

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, _params) do
    accounts = Users.list_users()
    render(conn, :index, accounts: accounts)
  end

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"account" => account_params, "user" => user_params}) do
    with {:ok, %Account{} = account} <- Accounts.create_account(account_params),
         {:ok, %User{} = user} <- Users.create_user(account, user_params) do
      conn
      |> put_status(:created)
      |> render(:created, %{account: account, user: user})
    end
  end

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    account = Users.get_user!(id)
    render(conn, :show, account: account)
  end

  @spec update(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def update(conn, %{"id" => id, "user" => user_params}) do
    account = Users.get_user!(id)

    with {:ok, %Account{} = account} <- Users.update_user(account, user_params) do
      render(conn, :show, account: account)
    end
  end

  @spec delete(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def delete(conn, %{"id" => id}) do
    account = Users.get_user!(id)
    ExcommerceApiWeb.AccountController.delete(conn, %{"id" => account.id})
  end
end
