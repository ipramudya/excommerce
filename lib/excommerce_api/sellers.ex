defmodule ExcommerceApi.Sellers do
  import Ecto.Query, warn: false

  alias ExcommerceApi.Repo
  alias ExcommerceApi.Accounts.Account
  alias ExcommerceApi.Accounts.Seller

  @spec list_sellers() :: [Seller.t()]
  def list_sellers do
    from(account in Account,
      inner_join: seller in Seller,
      on: seller.account_id == account.id,
      preload: [:seller]
    )
    |> Repo.all()
  end

  @spec get_seller!(binary()) :: Seller.t() | term()
  def get_seller!(id) do
    from(account in Account,
      inner_join: seller in Seller,
      on: seller.account_id == account.id,
      where: seller.id == ^id,
      preload: [:seller]
    )
    |> Repo.one()
  end

  @spec create_seller(map(), map()) :: {:ok, Seller.t()} | {:error, Ecto.Changeset.t()}
  def create_seller(account, seller_attrs) do
    account
    |> Map.replace(:role, "common")
    |> Ecto.build_assoc(:seller)
    |> Seller.changeset(seller_attrs)
    |> Repo.insert()
  end

  @spec update_seller(Account.t(), map()) :: {:ok, Account.t()} | {:error, Ecto.Changeset.t()}
  def update_seller(%Account{} = account, attrs) do
    remap_account_changeset =
      account
      |> Map.from_struct()
      |> Map.update!(:email, &(Map.get(attrs, "email") || &1))
      |> Map.update!(:seller, fn seller ->
        %{
          Map.from_struct(seller)
          | firstname: Map.get(attrs, "firstname") || seller.firstname,
            lastname: Map.get(attrs, "lastname") || seller.lastname,
            bio: Map.get(attrs, "bio") || seller.bio
        }
      end)

    account
    |> Repo.preload([:seller])
    |> Account.cast_update_seller_changeset(remap_account_changeset)
    |> Repo.update()
  end
end
