defmodule ExcommerceApiWeb.Router do
  alias ExcommerceApiWeb
  use ExcommerceApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth, do: plug(ExcommerceApiWeb.Auth.Pipeline)
  pipeline :ensure_superadmin, do: plug(ExcommerceApiWeb.UnsureSuperadmin)
  pipeline :ensure_admin, do: plug(ExcommerceApiWeb.EnsureAdmin)
  pipeline :ensure_seller, do: plug(ExcommerceApiWeb.EnsureSeller)

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
    plug ExcommerceApiWeb.AssignAccount
  end

  # ------------ public routes ------------
  scope "/api", ExcommerceApiWeb do
    pipe_through :api

    post "/signin", AuthController, :signin
    post "/users/register", UserController, :create
    post "/sellers/register", SellerController, :create
  end

  # ------------ superadmin authorization ------------
  scope "/api", ExcommerceApiWeb do
    pipe_through [:api, :auth, :ensure_auth, :ensure_superadmin]

    post "/accounts", AccountController, :create
    delete "/accounts/:id", AccountController, :delete
    put "/accounts/:id/role", AccountController, :change_role
  end

  # ------------ admin authorization ------------
  scope "/api", ExcommerceApiWeb do
    pipe_through [:api, :auth, :ensure_auth, :ensure_admin]

    get "/accounts", AccountController, :index
    get "/accounts/:id", AccountController, :show

    get "/users", UserController, :index
    get "/users/:id", UserController, :show
    post "/users", UserController, :create
    put "/users/:id", UserController, :update
    delete "/users/:id", UserController, :delete

    get "/sellers", SellerController, :index
    get "/sellers/:id", SellerController, :show
    post "/sellers", SellerController, :create
    put "/sellers/:id", SellerController, :update
    delete "/sellers/:id", SellerController, :delete

    get "/shops/all", ShopController, :all
  end

  # ------------ seller authorization ------------
  scope "/api/shops", ExcommerceApiWeb do
    pipe_through [:api, :auth, :ensure_auth, :ensure_seller]

    get "/", ShopController, :index
    get "/:id", ShopController, :show
    post "/", ShopController, :create
    put "/:id", ShopController, :update
    delete "/:id", ShopController, :delete

    get "/:shop_id/products", ProductController, :index
    get "/products/:id", ProductController, :show
    post "/:shop_id/products", ProductController, :create
    put "/products/:id", ProductController, :update
    delete "/products/:id", ProductController, :delete

    post "/products/:product_id/discount", DiscountController, :create
    put "/discount/:id", DiscountController, :update
    delete "/discount/:id", DiscountController, :revoke
  end

  # ------------ basic authorization ------------
  scope "/api", ExcommerceApiWeb do
    pipe_through [:api, :auth, :ensure_auth]

    get "/users-me", UserController, :me
    post "/users-me/password", UserController, :change_password

    get "/sellers-me", SellerController, :me
    post "/sellers-me/password", SellerController, :change_password
  end
end
