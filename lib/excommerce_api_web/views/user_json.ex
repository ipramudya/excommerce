defmodule ExcommerceApiWeb.UserJSON do
  def index(%{accounts: accounts}) do
    %{data: for(account <- accounts, do: remap_data_not_creation(account))}
  end

  def created(%{user: user, account: account, address: address}) do
    %{
      data: %{
        account_id: account.id,
        email: account.email,
        firstname: user.firstname,
        id: user.id,
        lastname: user.lastname,
        address: Map.take(address, [:id, :full_line, :city, :province, :postal_code])
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
      address: Map.take(data.user.address, [:id, :full_line, :province, :city, :postal_code])
    }
  end
end
