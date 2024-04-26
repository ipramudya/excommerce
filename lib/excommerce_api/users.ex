defmodule ExcommerceApi.Users do
  import Ecto.Query, warn: false

  alias ExcommerceApi.Repo
  alias ExcommerceApi.Accounts.{Account, User}

  @spec list_users() :: [Account.t()]
  def list_users do
    query =
      from(
        a in Account,
        join: u in User,
        on: a.id == u.account_id,
        preload: :user
      )

    Repo.all(query)
  end

  @spec get_user!(binary()) :: Account.t() | term()
  def get_user!(id) do
    query =
      from(a in Account,
        join: u in User,
        on: a.id == u.account_id,
        preload: :user,
        where: u.id == ^id
      )

    Repo.one!(query)
  end

  @spec create_user(map(), map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create_user(account, user_attrs) do
    account
    |> Map.replace(:role, "common")
    |> Ecto.build_assoc(:user)
    |> User.changeset(user_attrs)
    |> Repo.insert()
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
