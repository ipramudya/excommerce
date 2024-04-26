defmodule ExcommerceApiWeb.AuthController do
  use ExcommerceApiWeb, :controller

  alias ExcommerceApiWeb.{Auth, AccountJSON}

  def signin(conn, %{"email" => email, "password" => password}) do
    with {:ok, account, token} <- Auth.Guardian.authenticate(email, password) do
      conn
      |> put_view(json: AccountJSON)
      |> render(:show_with_token, %{account: account, token: token})
    end
  end

  def user_me(conn, _params) do
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
end
