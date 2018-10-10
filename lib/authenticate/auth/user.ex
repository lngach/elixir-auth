defmodule Authenticate.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]


  schema "users" do
    field :confirmation_sent_at, :naive_datetime
    field :confirmation_token, :string
    field :confirmed_at, :naive_datetime
    field :current_sign_in_at, :naive_datetime
    field :current_sign_in_ip, :string
    field :disable, :boolean, default: false
    field :email, :string
    field :failed_attempts, :integer
    field :image, :string
    field :last_sign_in_at, :naive_datetime
    field :last_sign_in_ip, :string
    field :locked_at, :naive_datetime
    field :name, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :encrypted_password, :string
    field :provider, :string
    field :reset_password_sent_at, :string
    field :reset_password_token, :string
    field :sign_in_count, :integer
    field :tokens, :string
    field :uid, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:password, :name, :username, :image, :email, :provider, :uid])
    |> validate_required([:name, :username, :image, :email, :password])
    |> unique_constraint(:email)
    |> unique_constraint(:username)
    |> unique_constraint(:uid, name: :users_uid_provider_index)
    |> unique_constraint(:provider, name: :users_uid_provider_index)
    |> unique_constraint(:reset_password_token)
    |> unique_constraint(:confirmation_token)
    |> validate_format(:email, ~r/@/)
    |> validate_provider(:provider)
    |> validate_password(:password)
    |> validate_confirmation(:password)
    |> encrypt_password()
  end

  def validate_password(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, password ->
      case valid_password?(password) do
        {:ok, _} -> []
        {:error, msg} -> [{field, options[:message] || msg}]
      end
    end)
  end

  defp valid_password?(password) when byte_size(password) > 7, do: {:ok, password}
  defp valid_password?(_), do: {:error, "The password is invalid"}

  defp encrypt_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, encrypted_password: hashpwsalt(password))
  end
  defp encrypt_password(changeset), do: changeset

  defp validate_provider(%Ecto.Changeset{valid?: true, changes: %{email: email}} = changeset, provider) do
      case valid_provider?(provider) do
        false -> change(changeset, provider: email)
      end
  end
  defp validate_provider(changeset, _field), do: changeset
  defp valid_provider?(provider) when provider == "email", do: false
  defp valid_provider?(_), do: false


end
