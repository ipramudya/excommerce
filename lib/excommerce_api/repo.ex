defmodule ExcommerceApi.Repo do
  use Ecto.Repo,
    otp_app: :excommerce_api,
    adapter: Ecto.Adapters.Postgres
end
