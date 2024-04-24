defmodule ExcommerceApiWeb.UserJSON do
  alias ExcommerceApi.{Accounts.Account, Users.User}

  def index(%{accounts: accounts}) do
    %{data: for(account <- accounts, do: remap_data_not_creation(account))}
  end

  def created(%{user: %User{} = user, account: %Account{} = account}) do
    %{
      data: %{
        account_id: account.id,
        email: account.email,
        firstname: user.firstname,
        id: user.id,
        lastname: user.lastname,
        logout_at: account.logout_at
      }
    }
  end

  def show(%{account: account}) do
    %{data: remap_data_not_creation(account)}
  end

  defp remap_data_not_creation(data) do
    %{
      account_id: data.id,
      email: data.email,
      firstname: data.user.firstname,
      id: data.user.id,
      lastname: data.user.lastname,
      logout_at: data.logout_at
    }
  end
end
