defmodule ExcommerceApiWeb.Auth.Guardian do
  alias ExcommerceApi.Context.Accounts
  use Guardian, otp_app: :excommerce_api

  def subject_for_token(account, _claims) do
    {:ok, account.id}
  end

  def resource_from_claims(%{"sub" => id}) do
    account = Accounts.get_account!(id)
    {:ok, account}
  end

  def authenticate(email, plain_password) do
    case Accounts.get_by_email(email) do
      nil ->
        Bcrypt.no_user_verify()
        {:error, "Invalid credentials"}

      account ->
        if Bcrypt.verify_pass(plain_password, account.password) do
          write_token(account)
        else
          {:error, "Invalid credentials"}
        end
    end
  end

  defp write_token(account) do
    {:ok, token, _claims} = encode_and_sign(account, %{}, token_type: "refresh", ttl: {4, :weeks})
    {:ok, account, token}
  end
end
