defmodule Authenticate.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :provider, :string, default: "email", null: false
      add :uid, :string, default: "", null: false
      add :password, :string, default: "", null: false
      add :reset_password_token, :string
      add :reset_password_sent_at, :string
      add :sign_in_count, :integer, default: 0, null: false
      add :current_sign_in_at, :naive_datetime
      add :last_sign_in_at, :naive_datetime
      add :current_sign_in_ip, :string
      add :last_sign_in_ip, :string
      add :confirmation_token, :string
      add :confirmed_at, :naive_datetime
      add :confirmation_sent_at, :naive_datetime
      add :failed_attempts, :integer, defualt: 0, null: false
      add :locked_at, :naive_datetime
      add :disable, :boolean, default: false, null: false
      add :name, :string
      add :username, :string
      add :image, :string
      add :email, :string
      add :tokens, :text

      timestamps()
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:username])
    create unique_index(:users, [:uid, :provider])
    create unique_index(:users, [:reset_password_token])
    create unique_index(:users, [:confirmation_token])
  end
end
