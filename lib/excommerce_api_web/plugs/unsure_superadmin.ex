defmodule ExcommerceApiWeb.UnsureSuperadmin do
  import Plug.Conn
  alias ExcommerceApiWeb.Auth.Guardian.Plug, as: GuardianPlug

  def init(opts), do: opts

  def call(conn, _opts) do
    account = GuardianPlug.current_resource(conn)

    unless account.role == "superadmin" do
      body =
        Poison.encode!(%{
          errors: %{
            message: "Unauthorized account",
            detail: "Resource under superadmin privilage"
          }
        })

      conn
      |> put_resp_content_type("application/json")
      |> send_resp(403, body)
    else
      conn
    end
  end
end
