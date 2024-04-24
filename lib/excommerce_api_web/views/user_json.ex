defmodule ExcommerceApiWeb.UserJSON do
  alias ExcommerceApi.{Accounts.Account, Users.User}

  @doc """
  Renders a list of users.
  """
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

  @spec created(%{:account => Account.t(), :user => User.t()}) :: map()
  def created(%{user: %User{} = user, account: %Account{} = account}) do
    %{
      id: account.id,
      email: account.email,
      logout_at: account.logout_at,
      user: %{
        id: user.id,
        firstname: user.firstname,
        lastname: user.lastname
      }
    }
  end
end
