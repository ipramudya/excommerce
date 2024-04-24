defmodule ExcommerceApiWeb.UserController do
  use ExcommerceApiWeb, :controller

  alias ExcommerceApi.{Accounts, Accounts.Account, Users, Users.User}

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
      |> render(:created, data: %{account: account, user: user})
    end
  end

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    account = Users.get_user!(id)
    IO.inspect(account)
    render(conn, :show, account: account)
  end

  @spec update(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)

    with {:ok, %User{} = user} <- Users.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  @spec delete(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)

    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
