defmodule ExcommerceApiWeb.AccountJSON do
  alias ExcommerceApi.Accounts.Account

  def index(%{accounts: accounts}) do
    %{data: for(account <- accounts, do: data(account))}
  end

  def show(%{account: account}) do
    %{data: data(account)}
  end

  def show_with_token(%{account: account, token: token}) do
    %{data: data(account), token: token}
  end

  defp data(%Account{} = account) do
    user =
      case Map.fetch(account, :user) do
        {:ok, nil} ->
          nil

        {:ok, user} ->
          %{
            id: user.id,
            firstname: user.firstname,
            lastname: user.lastname
          }
      end

    %{
      id: account.id,
      email: account.email,
      logout_at: account.logout_at,
      role: account.role,
      seller: nil,
      user: user
    }
  end
end
