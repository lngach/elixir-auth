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

  def render("jwt.json", %{jwt: jwt}) do
    %{
      data: %{
        access_token: jwt,
        message: "Signed in successfully!"
      }
    }
  end

  def render("sign_in_failed.json", %{message: msg}) do
    %{
      data: %{
        error: %{
          message: msg
        }
      }
    }
  end

end
