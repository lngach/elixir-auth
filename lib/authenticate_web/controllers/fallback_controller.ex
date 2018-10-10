defmodule AuthenticateWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use AuthenticateWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(AuthenticateWeb.ChangesetView, "error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(AuthenticateWeb.ErrorView, :"404")
  end

  def call(conn, {:error, :unauthorized, message}) do
    conn
    |> put_status(:unauthorized)
    |> render(AuthenticateWeb.ErrorView, "401.json", message: message)
  end

end
