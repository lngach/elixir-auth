defmodule Authenticate.Email do
  import Bamboo.Email
  import Bamboo.Phoenix

  def forgot_password(user) do
    base_email()
    |> to(user.email)
    |> subject("Password Reset!!!")
    |> put_header("Reply-to", "iklearn2018@gmail.com")
    |> html_body("<strong>"<>user.reset_password_sent_at.to_string()<>": "<>user.reset_password_token<>"</strong>")
    |> text_body(user.reset_password_sent_a.to_string()<>": "<>user.reset_password_token)
  end

  defp base_email do
    new_email()
    |> from("iklearn2018@gmail.com")
    |> put_html_layout({Authenticate.LayoutView, "email.html"})
    |> put_text_layout({Authenticate.LayoutView, "email.text"})
  end
end
