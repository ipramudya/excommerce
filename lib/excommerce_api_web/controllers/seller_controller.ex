defmodule ExcommerceApiWeb.SellerController do
  use ExcommerceApiWeb, :controller

  alias ExcommerceApi.{Accounts.Account, Accounts, Sellers}

  action_fallback ExcommerceApiWeb.FallbackController

  def index(conn, _params) do
    accounts = Sellers.list_sellers()
    render(conn, :index, accounts: accounts)
  end

  def create(conn, %{"account" => account_params, "seller" => seller_params}) do
    with {:ok, %Account{} = account} <- Accounts.create_account(account_params) do
      case Sellers.create_seller(account, seller_params) do
        {:ok, created_seller} ->
          conn
          |> put_status(:created)
          |> render(:created, %{
            account: account,
            seller: created_seller
          })

        {:error, create_seller_changeset_error} ->
          case Accounts.delete_account(account) do
            {:ok, _transaction} ->
              {:error, create_seller_changeset_error}

            _ ->
              conn
              |> put_status(:internal_server_error)
              |> json(%{
                errors: %{
                  message: "Something went wrong, cannot create seller and please try again."
                }
              })
          end
      end
    end
  end

  def show(conn, %{"id" => id}) do
    account = Sellers.get_seller!(id)
    render(conn, :show, account: account)
  end

  def update(conn, %{"id" => id, "seller" => seller_param}) do
    account = Sellers.get_seller!(id)

    with {:ok, seller} <- Sellers.update_seller(account, seller_param) do
      render(conn, :show, account: seller)
    end
  end

  def delete(conn, %{"id" => id}) do
    account = Sellers.get_seller!(id)
    ExcommerceApiWeb.AccountController.delete(conn, %{"id" => account.id})
  end

  def me(conn, _params) do
    account = conn.assigns.current_account

    if is_nil(account.seller) do
      conn
      |> put_status(:not_found)
      |> json(%{errors: %{message: "There is no seller on this associated account"}})
    else
      conn
      |> put_view(ExcommerceApiWeb.SellerJSON)
      |> render(:show, account: account)
    end
  end

  def change_password(conn, %{"new_password" => new_pass, "current_password" => curr_pass}) do
    account = conn.assigns.current_account

    if is_nil(account.seller) do
      conn
      |> put_status(:not_found)
      |> json(%{errors: %{message: "There is no seller on this associated account"}})
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
