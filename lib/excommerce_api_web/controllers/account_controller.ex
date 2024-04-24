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

  @spec delete(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def delete(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)

    with {:ok, %Account{}} <- Accounts.delete_account(account) do
      conn
      |> put_status(:accepted)
      |> json(%{data: %{status: "success"}})
    end

    # def create(conn, %{"account" => account_params}) do
    #   with {:ok, %Account{} = account} <- Accounts.create_account(account_params) do
    #     conn
    #     |> put_status(:created)
    #     |> put_resp_header("location", ~p"/api/accounts/#{account}")
    #     |> render(:show, account: account)
    #   end
    # end

    # def update(conn, %{"id" => id, "account" => account_params}) do
    #   account = Accounts.get_account!(id)

    #   with {:ok, %Account{} = account} <- Accounts.update_account(account, account_params) do
    #     render(conn, :show, account: account)
    #   end
    # end

    # with {:ok, %Account{}} <- Accounts.delete_account(account) do
    #   send_resp(conn, :no_content, "")
    # end
  end
end
