defmodule ExcommerceApiWeb.UserJSON do
  alias ExcommerceApi.{Accounts.Account, Users.User}

  def index(%{accounts: accounts}) do
    %{
      data:
        for(
          account <- accounts,
          do: %{
            id: account.user.id,
            email: account.email,
            logout_at: account.logout_at,
            firstname: account.user.firstname,
            lastname: account.user.lastname
          }
        )
    }
  end

  def created(%{user: %User{} = user, account: %Account{} = account}) do
    %{
      data: %{
        id: user.id,
        email: account.email,
        logout_at: account.logout_at,
        firstname: user.firstname,
        lastname: user.lastname
      }
    }
  end

  def show(%{account: account}) do
    %{
      data: %{
        id: account.user.id,
        email: account.email,
        logout_at: account.logout_at,
        firstname: account.user.firstname,
        lastname: account.user.lastname
      }
    }
  end
end
