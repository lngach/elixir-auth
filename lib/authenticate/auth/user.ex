defmodule Authenticate.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset


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
    |> cast(attrs, [:provider, :uid, :password , :encrypted_password, :reset_password_token, :reset_password_sent_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :confirmation_token, :confirmed_at, :confirmation_sent_at, :failed_attempts, :locked_at, :disable, :name, :username, :image, :email, :tokens])
    |> validate_required([:name, :username, :image, :email, :password])
    |> unique_constraint(:email)
    |> unique_constraint(:username)
    |> unique_constraint(:uid, name: :users_uid_provider_index)
    |> unique_constraint(:provider, name: :users_uid_provider_index)
    |> unique_constraint(:reset_password_token)
    |> unique_constraint(:confirmation_token)
    |> validate_format(:email, ~r/@/)
    # |> validate_provider(:provider)
    |> validate_password(:password)
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
    change(changeset, Comeonin.Bcrypt.add_hash(password))
  end
  defp encrypt_password(changeset), do: changeset

  # def validate_provider(changeset, field) do
  #   validate_change(changeset, field, fn _, provider ->
  #     if !valid_provider?(provider) do
  #       email = elem(fetch_field(changeset, :email), 1)
  #       change(changeset, provider: email)
  #     end
  #   end)
  # end

  # defp valid_provider?(_), do: false

end
