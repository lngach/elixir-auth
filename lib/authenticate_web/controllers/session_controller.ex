defmodule AuthenticateWeb.SessionController do
  use AuthenticateWeb, :controller

  alias Authenticate.Guardian
  alias Authenticate.Auth.User

  action_fallback AuthenticateWeb.FallbackController

  def sign_in(conn, %{"id" => id, "password" => password}) do
    case Authenticate.Auth.authenticate_user(id, password) do
      {:lock, msg} ->
        conn
        |> put_status(:unauthorized)
        |> render(AuthenticateWeb.SessionView, "sign_in_failed.json", message: msg)
      {:ok, user} ->
        with  {:ok, token, _claims} <- Guardian.encode_and_sign(user),
              {:ok, %User{} = _user} <- Authenticate.Auth.update_user(user, %{tokens: token, sign_in_count: user.sign_in_count + 1}) do
          conn
          |> put_status(:ok)
          |> render(AuthenticateWeb.SessionView, "jwt.json", jwt: token)
        end
      {:error, :not_found} ->
        {:error, :unauthorized, "Login id or password is Invalid"}
      {:wrong_password, user} ->
        case user.failed_attempts do
          x when x in [0, 1, 2, 3] ->
            with  {:ok, %User{} = _user} <- Authenticate.Auth.update_user(user, %{failed_attempts: x + 1}) do
              conn
              |> put_status(:unauthorized)
              |> render(AuthenticateWeb.SessionView, "sign_in_failed.json", message: "Password is invalid, You have login with invalid password #{x + 1} times.\nReach 5 times your account will be locked!")
            end
          4 ->
            with  {:ok, %User{} = _user} <- Authenticate.Auth.update_user(user, %{failed_attempts: 5, disable: true, locked_at: NaiveDateTime.utc_now()}) do
              conn
              |> put_status(:unauthorized)
              |> render(AuthenticateWeb.SessionView, "sign_in_failed.json", message: "Password is invalid, You have login with invalid password 5 times.\nYour account is locked!")
            end
        end
    end
  end

end
