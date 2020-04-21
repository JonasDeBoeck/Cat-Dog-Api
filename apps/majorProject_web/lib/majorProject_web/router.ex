defmodule MajorProjectWeb.Router do
  use MajorProjectWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :majorProject do
    plug MajorProjectWeb.Pipeline
  end

  pipeline :auth do
    plug MajorProjectWeb.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :allowed_for_users do
    plug MajorProjectWeb.Plugs.AuthorizationPlug, ["Admin", "User"]
  end

  pipeline :allowed_for_admins do
    plug MajorProjectWeb.Plugs.AuthorizationPlug, ["Admin"]
  end

  scope "/", MajorProjectWeb do
    pipe_through [:browser, :majorProject]

    get "/", PageController, :index
    get "/login", SessionController, :new
    post "/login", SessionController, :login
    get "/logout", SessionController, :logout
  end

  scope "/", MajorProjectWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_users]

    get "/user_scope", UserController, :index
    get "/profile", UserController, :profile
  end

  scope "/admin", MajorProjectWeb do
    pipe_through [:browser, :majorProject, :ensure_auth, :auth, :allowed_for_admins]
    get "/users", UserController, :users
  end

  scope "/api", MajorProjectWeb do
    pipe_through :api
    resources "/users", UserController, only: [] do
      resources "/animals", AnimalController
      get "/animals/:id/details", AnimalController, :show_details
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", MajorProjectWeb do
  #   pipe_through :api
  # end
end
