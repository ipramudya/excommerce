defmodule ExcommerceApiWeb.Router do
  use ExcommerceApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ExcommerceApiWeb do
    pipe_through :api
  end
end
