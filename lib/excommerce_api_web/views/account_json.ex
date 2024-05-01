defmodule ExcommerceApiWeb.AccountJSON do
  alias ExcommerceApi.Schema.Accounts.Account

  def index(%{accounts: accounts}) do
    %{accounts: for(account <- accounts, do: data(account))}
  end

  def show(%{account: account}) do
    %{account: data(account)}
  end

  def show_with_token(%{account: account, token: token}) do
    %{account: data(account), token: token}
  end

  defp data(%Account{} = account) do
    user =
      account
      |> Map.get(:user)
      |> case do
        nil -> nil
        map -> Map.take(map, [:id, :firstname, :lastname])
      end

    seller =
      account
      |> Map.get(:seller)
      |> case do
        nil -> nil
        map -> Map.take(map, [:id, :firstname, :lastname, :bio])
      end

    %{
      id: account.id,
      email: account.email,
      role: account.role,
      seller: seller,
      user: user
    }
  end
end
