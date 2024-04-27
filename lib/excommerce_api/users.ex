defmodule ExcommerceApi.Users do
  import Ecto.Query, warn: false

  alias ExcommerceApi.Address
  alias ExcommerceApi.Repo
  alias ExcommerceApi.Accounts.User
  alias ExcommerceApi.Accounts.Account

  @spec list_users() :: [Account.t()]
  def list_users do
    query =
      from account in Account,
        inner_join: user in User,
        on: user.account_id == account.id,
        preload: [user: [:address]]

    Repo.all(query)
  end

  @spec get_user!(binary()) :: Account.t() | term()
  def get_user!(id) do
    query =
      from account in Account,
        inner_join: user in User,
        on: user.account_id == account.id,
        where: user.id == ^id,
        preload: :user

    Repo.one!(query)
  end

  @spec create_user(map(), map()) :: {:ok, any()} | {:error, any()} | Ecto.Multi.failure()
  def create_user(account, user_attrs) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :user,
      account
      |> Map.replace(:role, "common")
      |> Ecto.build_assoc(:user)
      |> User.changeset(user_attrs)
    )
    |> Ecto.Multi.insert(
      :address,
      %Address{}
      |> Address.changeset(user_attrs["address"])
    )
    |> Ecto.Multi.update(:user_update, fn %{user: user, address: address} ->
      user
      |> Ecto.Changeset.change(%{address_id: address.id})
    end)
    |> Repo.transaction()
  end

  @spec update_user(Account.t(), map()) :: {:ok, Account.t()} | {:error, Ecto.Changeset.t()}
  def update_user(%Account{} = account, attrs) do
    case attrs do
      %{"email" => email, "firstname" => firstname, "lastname" => lastname} ->
        remap_attrs =
          account
          |> Map.from_struct()
          |> Map.replace(:email, email)
          |> Map.update(:user, nil, fn user ->
            %{
              Map.from_struct(user)
              | firstname: firstname,
                lastname: lastname
            }
          end)

        account
        |> Repo.preload(:user)
        |> Account.update_changeset(remap_attrs)
        |> Repo.update()

      _ ->
        {:error, :bad_request}
    end
  end
end
