defmodule ExcommerceApiWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :excommerce_api,
    error_handler: ExcommerceApiWeb.Auth.GuardianError,
    module: ExcommerceApiWeb.Auth.Guardian

  # If there is an authorization header, restrict it to an refresh token and validate it
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "refresh"}
  # Load the user if either of the verifications worked
  plug Guardian.Plug.LoadResource, allow_blank: true
end
