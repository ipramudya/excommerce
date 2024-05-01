defmodule ExcommerceApiWeb.UserController do
  use ExcommerceApiWeb, :controller

  alias ExcommerceApi.Context.{Accounts, Users}
  alias ExcommerceApi.Schema.Accounts.Account

  action_fallback ExcommerceApiWeb.FallbackController

  def index(conn, _params) do
    accounts = Users.list_users()
    render(conn, :index, accounts: accounts)
  end

  def create(conn, %{"account" => account_params, "user" => user_params}) do
    with {:ok, %Account{} = account} <- Accounts.create_account(account_params) do
      case Users.create_user(account, user_params) do
        {:ok, created_user_transaction} ->
          conn
          |> put_status(:created)
          |> render(:created, %{
            account: account,
            user: created_user_transaction.user,
            address: created_user_transaction.address
          })

        {:error, create_user_changeset_error} ->
          case Accounts.delete_account(account) do
            {:ok, _transaction} ->
              {:error, create_user_changeset_error}

            _ ->
              conn
              |> put_status(:internal_server_error)
              |> json(%{
                errors: %{
                  message: "Something went wrong, cannot create user and please try again."
                }
              })
          end
      end
    end
  end

  def show(conn, %{"id" => id}) do
    account = Users.get_user!(id)
    render(conn, :show, account: account)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    account = Users.get_user!(id)

    with {:ok, %Account{} = account} <- Users.update_user(account, user_params) do
      render(conn, :show, account: account)
    end
  end

  def delete(conn, %{"id" => id}) do
    account = Users.get_user!(id)
    ExcommerceApiWeb.AccountController.delete(conn, %{"id" => account.id})
  end

  def me(conn, _params) do
    account = conn.assigns.current_account

    if is_nil(account.user) do
      conn
      |> put_status(:not_found)
      |> json(%{errors: %{message: "There is no user on this associated account"}})
    else
      conn
      |> put_view(ExcommerceApiWeb.UserJSON)
      |> render(:show, account: account)
    end
  end

  def change_password(conn, %{"new_password" => new_pass, "current_password" => curr_pass}) do
    account = conn.assigns.current_account

    if is_nil(account.user) do
      conn
      |> put_status(:not_found)
      |> json(%{errors: %{message: "There is no user on this associated account"}})
    else
      with {:ok, _account} <-
             Accounts.change_password(account, %{
               new_password: new_pass,
               current_password: curr_pass
             }) do
        conn
        |> put_status(:ok)
        |> json(%{message: "Password successfully changed"})
      end
    end
  end
end
