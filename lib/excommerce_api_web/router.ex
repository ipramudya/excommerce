defmodule ExcommerceApiWeb.Router do
  alias ExcommerceApiWeb
  use ExcommerceApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ExcommerceApiWeb do
    pipe_through :api

    get "/accounts", AccountController, :index
    get "/accounts/:id", AccountController, :show
    delete "/accounts/:id", AccountController, :delete

    resources "/users", UserController, except: [:new, :edit, :update]
    put "/users/:id", UserController, :update
  end
end
