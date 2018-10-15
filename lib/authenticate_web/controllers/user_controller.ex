defmodule AuthenticateWeb.UserController do
  use AuthenticateWeb, :controller

  alias Authenticate.Auth
  alias Authenticate.Auth.User

  action_fallback AuthenticateWeb.FallbackController

  def index(conn, _params) do
    users = Auth.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Auth.create_user(user_params)do
      conn
      |> put_status(:created)
      |> put_resp_header("location", user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def profile(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    conn |> render("show.json", user: user)
 end

  def show(conn, %{"id" => id}) do
    user = Auth.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Auth.get_user!(id)

    with {:ok, %User{} = user} <- Auth.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Auth.get_user!(id)
    with {:ok, %User{}} <- Auth.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def forgot_password(conn, %{"email" => email}) do
    case Auth.forgot_password_user(email) do
      {:ok, user} ->
        token     = Authenticate.StringGenerator.randstring(20)
        sent_at   = NaiveDateTime.utc_now()
        with {:ok, %User{} = user} <- Auth.update_user(user, %{reset_password_token: token, reset_password_sent_at: sent_at}) do
          Authenticate.Email.forgot_password(user) |> Authenticate.Mailer.deliver_later
          conn  |> put_status(:ok) |> render("forgot_password.json", message: "Email has been sent!")
        end
      {:error, msg} -> conn |> put_status(:not_found) |> render("forgot_password.json", message: msg)
    end
  end

end
