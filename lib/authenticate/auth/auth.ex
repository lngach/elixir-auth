defmodule Authenticate.Auth do
  @moduledoc """
  The Auth context.
  """

  import Ecto.Query, warn: false
  alias Authenticate.Repo

  alias Authenticate.Auth.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def authenticate_user(id, password) do
    query = from(u in User, where: u.email == ^id or u.username == ^id)
    query |> Repo.one() |> verify_password(password)
  end

  defp verify_password(nil, _) do
    Comeonin.Bcrypt.dummy_checkpw()
    {:error, :not_found}
  end

  defp verify_password(user, password) do
    case user.disable do
      true -> {:lock, "Your account has been locked!"}
      false ->
        if Comeonin.Bcrypt.checkpw(password, user.encrypted_password) do
          {:ok, user}
        else
          {:wrong_password, user}
        end
    end
  end

  def forgot_password_user(email) do
    query = from(u in User, where: u.email == ^email)
    query |> Repo.one() |> forgot_password()
  end

  defp forgot_password(nil), do: {:error, "User was locked or not found"}

  defp forgot_password(user), do: {:ok, user}

  def reset_password_user(email, reset_password_token) do
    query = from(u in User, where: u.email == ^email)
    query |> Repo.one() |> verify_token(reset_password_token)
  end

  defp verify_token(user, reset_password_token) do
    if user.reset_password_token == reset_password_token and NaiveDateTime.diff(user.reset_password_sent_at, NaiveDateTime.utc_now()) <= 15*60 do
      {:ok, user}
    else
      {:error, "Invalid token or token has expired!"}
    end
  end

  def get_user_by_email!(email) do
    Repo.get_by(User, email: email)
  end


end
