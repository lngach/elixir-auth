defmodule AuthenticateWeb.SessionController do
  use AuthenticateWeb, :controller

  alias Authenticate.Guardian
  alias Authenticate.Auth.User

  action_fallback AuthenticateWeb.FallbackController

  def sign_in(conn, %{"id" => id, "password" => password}) do
    case Authenticate.Auth.authenticate_user(id, password) do
      {:ok, user} ->
        with  {:ok, token, _claims} <- Guardian.encode_and_sign(user),
              {:ok, %User{} = _user} <- Authenticate.Auth.update_user(user, %{tokens: token, sign_in_count: user.sign_in_count + 1}) do
          conn
          |> put_status(:ok)
          |> render(AuthenticateWeb.SessionView, "jwt.json", jwt: token)
        end
      {:error, message} ->
          {:error, :unauthorized, message}
    end
  end

end
