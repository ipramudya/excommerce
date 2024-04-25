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
end
