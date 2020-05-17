defmodule MajorProjectWeb.Router do
  use MajorProjectWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug MajorProjectWeb.Plugs.Locale
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

    get "/", SessionController, :new
    post "/login", SessionController, :login
    get "/logout", SessionController, :logout
    get "/register", UserController, :new
    post "/register", UserController, :create
  end

  scope "/", MajorProjectWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_users]

    get "/user_scope", UserController, :index
    get "/profile", UserController, :profile
    get "/editUsername", UserController, :edit_username
    put "/editUsername", UserController, :update_username
    get "/editPassword", UserController, :edit_password
    put "/editPassword", UserController, :update_password
    post "/createKey", UserController, :create_api
    get "/key/:api_id", UserController, :show_key
    delete "/key/:api_id", UserController, :delete_key
  end

  scope "/admin", MajorProjectWeb do
    pipe_through [:browser, :majorProject, :ensure_auth, :auth, :allowed_for_admins]
    get "/users", UserController, :users
    get "/edit/:user_id", UserController, :edit
    put "/edit/:user_id", UserController, :update
    delete "/users/:user_id", UserController, :delete
    get "/register", UserController, :register
    post "/register", UserController, :register_user
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
