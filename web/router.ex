defmodule Goncord.Router do
  use Goncord.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug Goncord.Plug.ResourceToken
    plug Goncord.Plug.JwtCookie
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug Guardian.Plug.EnsureAuthenticated, handler: Goncord.TokenController
  end

  pipeline :super_resource do
    plug Guardian.Plug.EnsureAuthenticated, handler: Goncord.TokenController
    plug Goncord.Plug.IsSuperResource
  end

  scope "/api", Goncord do
    pipe_through(:api)

    scope "/v0" do
        resources "/users", UserController, only: [:create]
        resources "/tokens", TokenController, only: [:create]
    end

    scope "/v0" do
      pipe_through(:api_auth)

      delete "/tokens", TokenController, :delete
      get "/tokens/validate", TokenController, :validate

      post "/users/change_password", UserController, :change_password

      get "/menu", MenuController, :get_menu
    end

    scope "/v0" do
      pipe_through(:super_resource)

      post "/roles", RoleController, :add_role
      delete "/roles", RoleController, :delete_role

      patch "/users", UserController, :update
    end
  end
end
