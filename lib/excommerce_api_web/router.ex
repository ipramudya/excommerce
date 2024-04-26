defmodule ExcommerceApiWeb.Router do
  alias ExcommerceApiWeb
  use ExcommerceApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug ExcommerceApiWeb.Auth.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  # ------------ public routes ------------
  scope "/api", ExcommerceApiWeb do
    pipe_through :api

    post "/signin", AuthController, :signin

    get "/users", UserController, :index
    get "/users/:id", UserController, :show
    post "/users", UserController, :create
    post "/accounts", AccountController, :create
  end

  # ------------ private routes ------------
  scope "/api", ExcommerceApiWeb do
    pipe_through [:api, :auth, :ensure_auth]

    # superadmin/admin authorization
    get "/accounts", AccountController, :index
    get "/accounts/:id", AccountController, :show
    delete "/accounts/:id", AccountController, :delete
    put "/accounts/:id/role", AccountController, :change_role

    put "/users/:id", UserController, :update
    delete "/users/:id", UserController, :delete
  end
end
