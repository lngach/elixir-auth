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
      provider: user.provider,
      name: user.name,
      username: user.username,
      image: user.image,
      email: user.email}
  end
end
