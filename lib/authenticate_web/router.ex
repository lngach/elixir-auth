defmodule AuthenticateWeb.Router do
  use AuthenticateWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", AuthenticateWeb do
    pipe_through :api
    resources "/users", UserController, except: [:new, :edit]
    post("/auth/sign_in", SessionController, :sign_in)
  end
end
