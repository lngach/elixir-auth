defmodule Authenticate.Email do
  import Bamboo.Email
  use Bamboo.Phoenix, view: AuthenticateWeb.EmailView

  def forgot_password(user) do
    base_email()
    |> to(user.email)
    |> subject("Password Reset!!!")
    |> put_header("Reply-to", "iklearn2018@gmail.com")
    |> assign(:user, user)
    |> render("forgot_password.html")
  end

  defp base_email do
    new_email()
    |> from("iklearn2018@gmail.com")
    |> put_html_layout({AuthenticateWeb.LayoutView, "email.html"})
  end
end

