defmodule AuthenticateWeb.SessionView do
  use AuthenticateWeb, :view

  def render("sign_in.json", %{user: user}) do
    %{
      data: %{
        user: %{
          id: user.id,
          name: user.name,
          email: user.email,
          username: user.username,
          image: user.image
        }
      }
    }
  end
end
