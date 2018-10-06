defmodule AuthenticateWeb.UserView do
  use AuthenticateWeb, :view
  alias AuthenticateWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      uid: user.uid,
      provider: user.provider,
      password: user.password,
      reset_password_token: user.reset_password_token,
      reset_password_sent_at: user.reset_password_sent_at,
      sign_in_count: user.sign_in_count,
      current_sign_in_at: user.current_sign_in_at,
      last_sign_in_at: user.last_sign_in_at,
      current_sign_in_ip: user.current_sign_in_ip,
      last_sign_in_ip: user.last_sign_in_ip,
      confirmation_token: user.confirmation_token,
      confirmed_at: user.confirmed_at,
      confirmation_sent_at: user.confirmation_sent_at,
      failed_attempts: user.failed_attempts,
      locked_at: user.locked_at,
      disable: user.disable,
      name: user.name,
      username: user.username,
      image: user.image,
      email: user.email,
      tokens: user.tokens}
  end
end
