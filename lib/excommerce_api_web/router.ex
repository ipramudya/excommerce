defmodule ExcommerceApiWeb.Router do
  alias ExcommerceApiWeb
  use ExcommerceApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth, do: plug(ExcommerceApiWeb.Auth.Pipeline)
  pipeline :ensure_superadmin, do: plug(ExcommerceApiWeb.UnsureSuperadmin)
  pipeline :ensure_admin, do: plug(ExcommerceApiWeb.EnsureAdmin)

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
    plug ExcommerceApiWeb.AssignAccount
  end

  # ------------ public routes ------------
  scope "/api", ExcommerceApiWeb do
    pipe_through :api

    post "/signin", AuthController, :signin
    post "/users/register", UserController, :create
  end

  # ------------ superadmin authorization ------------
  scope "/api", ExcommerceApiWeb do
    pipe_through [:api, :auth, :ensure_auth, :ensure_superadmin]

    # within superadmin/admin privilege
    get "/accounts", AccountController, :index
    get "/accounts/:id", AccountController, :show
    delete "/accounts/:id", AccountController, :delete
    put "/accounts/:id/role", AccountController, :change_role
  end

  # ------------ admin authorization ------------
  scope "/api", ExcommerceApiWeb do
    pipe_through [:api, :auth, :ensure_auth, :ensure_admin]

    get "/users", UserController, :index
    get "/users/:id", UserController, :show
    post "/accounts", AccountController, :create
  end

  # ------------ basic authorization ------------
  scope "/api", ExcommerceApiWeb do
    pipe_through [:api, :auth, :ensure_auth]

    put "/users/:id", UserController, :update
    delete "/users/:id", UserController, :delete
  end
end
