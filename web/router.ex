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
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug Guardian.Plug.EnsureAuthenticated, handler: Goncord.HttpErrorHandler
  end

  scope "/", Goncord do
    pipe_through(:browser)

    get "/", PageController, :index
  end

  scope "/api", Goncord do
    pipe_through(:api)

    scope "/v0" do
        resources "/users", UserController, only: [:create]
        resources "/tokens", TokenController, only: [:create]
    end

    scope "/v0" do
      pipe_through(:api_auth)

      resources "/users", UserController, only: [:show, :update]
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", Goncord do
  #   pipe_through :api
  # end
end
