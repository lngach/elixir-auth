defmodule AuthenticateWeb.SessionController do
  use AuthenticateWeb, :controller
  action_fallback AuthenticateWeb.FallbackController

  def sign_in(conn, %{"id" => id, "password" => password}) do
    case Authenticate.Auth.authenticate_user(id, password) do
      {:ok, user} ->
        conn
        |> put_status(:ok)
        |> render(AuthenticateWeb.SessionView, "sign_in.json", user: user)

      {:error, message} ->
        conn
        |> put_status(:unauthorized)
        |> render(AuthenticateWeb.ErrorView, "401.json", message: message)
    end
  end

end
