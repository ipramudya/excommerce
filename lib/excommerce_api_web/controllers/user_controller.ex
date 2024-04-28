defmodule ExcommerceApiWeb.UserController do
  use ExcommerceApiWeb, :controller

  alias ExcommerceApi.{Accounts, Accounts.Account, Users}

  action_fallback ExcommerceApiWeb.FallbackController

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, _params) do
    accounts = Users.list_users()
    render(conn, :index, accounts: accounts)
  end

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"account" => account_params, "user" => user_params}) do
    with {:ok, %Account{} = account} <- Accounts.create_account(account_params),
         {:ok, created_user_transaction} <- Users.create_user(account, user_params) do
      conn
      |> put_status(:created)
      |> render(:created, %{
        account: account,
        user: created_user_transaction[:user],
        address: created_user_transaction[:address]
      })
    end
  end

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    account = Users.get_user!(id)
    IO.inspect(["detail", account])
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

  def me(conn, _params) do
    account = conn.assigns.current_account

    if is_nil(account.user) do
      conn
      |> put_status(:not_found)
      |> json(%{errors: %{message: "There is no user on this accociated account"}})
    else
      conn
      |> put_view(ExcommerceApiWeb.UserJSON)
      |> render(:show, account: account)
    end
  end

  def change_password(conn, %{"new_password" => new_pass, "current_password" => curr_pass}) do
    account = conn.assigns.current_account

    with {:ok, account} <-
           Accounts.change_password(account, %{
             new_password: new_pass,
             current_password: curr_pass
           }) do
      conn
      |> put_view(ExcommerceApiWeb.UserJSON)
      |> render(:show, account: account)
    end
  end
end
