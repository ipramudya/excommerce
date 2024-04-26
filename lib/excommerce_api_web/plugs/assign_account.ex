defmodule ExcommerceApiWeb.AssignAccount do
  import Plug.Conn
  alias ExcommerceApiWeb.Auth.Guardian.Plug, as: GuardianPlug

  def init(opts), do: opts

  def call(conn, _opts) do
    case GuardianPlug.current_resource(conn) do
      nil ->
        conn

      account ->
        assign(conn, :current_account, account)
    end
  end
end
