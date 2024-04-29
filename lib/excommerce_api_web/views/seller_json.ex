defmodule ExcommerceApiWeb.SellerJSON do
  def index(%{accounts: accounts}) do
    %{sellers: for(account <- accounts, do: remap_data(account))}
  end

  def created(%{seller: seller, account: account}) do
    %{
      seller: %{
        account_id: account.id,
        bio: seller.bio,
        email: account.email,
        firstname: seller.firstname,
        id: seller.id,
        lastname: seller.lastname
      }
    }
  end

  def show(%{account: account}) do
    %{seller: remap_data(account)}
  end

  defp remap_data(data) do
    %{
      account_id: data.id,
      bio: data.seller.bio,
      email: data.email,
      firstname: data.seller.firstname,
      id: data.seller.id,
      lastname: data.seller.lastname
    }
  end
end
