defmodule AuthenticateWeb.Router do
  use AuthenticateWeb, :router
  alias Authenticate.Guardian

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Guardian.AuthPipeline
  end

  scope "/api", AuthenticateWeb do
    pipe_through [:api, :auth]
    resources "/users", UserController, except: [:new, :edit, :create]
    get "/profile", UserController, :profile
  end
  scope "/api", AuthenticateWeb do
    pipe_through [:api]
    resources "/users", UserController, only: [:create]
    post "/auth/sign_in", SessionController, :sign_in
  end

  if Mix.env == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end


end
