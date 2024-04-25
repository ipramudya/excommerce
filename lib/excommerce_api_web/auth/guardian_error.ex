defmodule ExcommerceApiWeb.Auth.GuardianError do
  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, _reason}, _opts) do
    status = remap_status(type)
    body = Poison.encode!(%{errors: %{message: remap_error_message(type)}})

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, body)
  end

  defp remap_error_message(type) when is_atom(type) do
    case type do
      type when type in [:unauthenticated, :unauthorized] -> "Unauthorized account"
      :invalid_token -> "Invalid token"
      :no_resource_found -> "No resource found"
      :already_authenticated -> "Account is already authenticated"
    end
  end

  defp remap_status(type) when is_atom(type) do
    case type do
      type when type in [:unauthenticated, :unauthorized] -> 401
      :invalid_token -> 403
      :no_resource_found -> 204
      :already_authenticated -> 409
    end
  end
end
