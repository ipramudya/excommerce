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
    %{
      id: account.id,
      email: account.email,
      logout_at: account.logout_at,
      user: %{
        id: account.user.id,
        firstname: account.user.firstname,
        lastname: account.user.lastname
      },
      seller: nil
    }
  end
end
