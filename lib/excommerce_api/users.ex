defmodule ExcommerceApi.Users do
  import Ecto.Query, warn: false

  alias ExcommerceApi.Address
  alias ExcommerceApi.Repo
  alias ExcommerceApi.Accounts.User
  alias ExcommerceApi.Accounts.Account

  @spec list_users() :: [Account.t()]
  def list_users do
    from(account in Account,
      inner_join: user in User,
      on: user.account_id == account.id,
      preload: [user: [:address]]
    )
    |> Repo.all()
  end

  @spec get_user!(binary()) :: Account.t() | term()
  def get_user!(id) do
    from(account in Account,
      inner_join: user in User,
      on: user.account_id == account.id,
      where: user.id == ^id,
      preload: [user: [:address]]
    )
    |> Repo.one!()
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
      Address.changeset(%Address{}, user_attrs["address"])
    )
    |> Ecto.Multi.update(:user_update, fn %{user: user, address: address} ->
      Ecto.Changeset.change(user, %{address_id: address.id})
    end)
    |> Repo.transaction()
  end

  @spec update_user(Account.t(), map()) :: {:ok, any()} | {:error, any()} | Ecto.Multi.failure()
  def update_user(%Account{} = account, attrs) do
    update_user_response =
      Ecto.Multi.new()
      |> Ecto.Multi.update(:update_user, fn _params ->
        remap_account_changeset =
          account
          |> Map.from_struct()
          |> Map.update!(:email, &(Map.get(attrs, "email") || &1))
          |> Map.update!(:user, fn user ->
            %{
              Map.from_struct(user)
              | firstname: Map.get(attrs, "firstname") || user.firstname,
                lastname: Map.get(attrs, "lastname") || user.lastname
            }
          end)

        account
        |> Repo.preload(:user)
        |> Account.update_changeset(remap_account_changeset)
      end)
      |> Ecto.Multi.update(:update_address, fn _params ->
        address = account.user.address

        remap_address_changeset =
          case Map.get(attrs, "address") do
            nil ->
              address
              |> Map.from_struct()
              |> Map.take([:full_line, :city, :province, :postal_code])

            address_attrs ->
              address_keys =
                address
                |> Map.from_struct()
                |> Map.keys()
                |> Enum.map(&Atom.to_string(&1))

              for key <- address_keys, into: %{} do
                unless is_nil(Map.get(address_attrs, key)) do
                  {key, Map.get(address_attrs, key)}
                else
                  {key, Map.get(address, String.to_atom(key))}
                end
              end
              |> Map.take(["full_line", "city", "province", "postal_code"])
          end

        Address.changeset(address, remap_address_changeset)
      end)
      |> Repo.transaction()

    with {:ok, res} <- update_user_response do
      replaced_res = put_in(res.update_user.user.address, res.update_address)
      {:ok, replaced_res.update_user}
    end
  end
end
