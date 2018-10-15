defmodule Authenticate.AuthTest do
  use Authenticate.DataCase

  alias Authenticate.Auth

  describe "users" do
    alias Authenticate.Auth.User

    @valid_attrs %{confirmation_sent_at: ~N[2010-04-17 14:00:00.000000], confirmation_token: Faker.String.base64(20), confirmed_at: ~N[2010-04-17 14:00:00.000000], current_sign_in_at: ~N[2010-04-17 14:00:00.000000], current_sign_in_ip: "192.168.0.101", disable: false, email: Faker.Internet.safe_email(), failed_attempts: 42, image: Faker.Avatar.image_url(), last_sign_in_at: ~N[2010-04-17 14:00:00.000000], last_sign_in_ip: "192.168.0.103", locked_at: ~N[2010-04-17 14:00:00.000000], name: Faker.Name.name(), password: "123456789", provider: Faker.Internet.safe_email(), reset_password_sent_at: ~N[2010-04-17 14:00:00.000000], reset_password_token: Faker.String.base64(20), sign_in_count: 123, tokens: Faker.String.base64(20), uid: Faker.UUID.v4(), username: Faker.Internet.user_name()}
    @update_attrs %{confirmation_sent_at: ~N[2010-04-17 14:00:00.000000], confirmation_token: Faker.String.base64(20), confirmed_at: ~N[2010-04-17 14:00:00.000000], current_sign_in_at: ~N[2010-04-17 14:00:00.000000], current_sign_in_ip: "192.168.0.101", disable: false, email: Faker.Internet.safe_email(), failed_attempts: 42, image: Faker.Avatar.image_url(), last_sign_in_at: ~N[2010-04-17 14:00:00.000000], last_sign_in_ip: "192.168.0.103", locked_at: ~N[2010-04-17 14:00:00.000000], name: Faker.Name.name(), password: "123123123", provider: Faker.Internet.safe_email(), reset_password_sent_at: ~N[2010-04-17 14:00:00.000000], reset_password_token: Faker.String.base64(20), sign_in_count: 123, tokens: Faker.String.base64(20), uid: Faker.UUID.v4(), username: Faker.Internet.user_name()}
    @invalid_attrs %{confirmation_sent_at: nil, confirmation_token: nil, confirmed_at: nil, current_sign_in_at: nil, current_sign_in_ip: nil, disable: nil, email: nil, failed_attempts: nil, image: nil, last_sign_in_at: nil, last_sign_in_ip: nil, locked_at: nil, name: nil, password: nil, provider: nil, reset_password_sent_at: nil, reset_password_token: nil, sign_in_count: nil, tokens: nil, uid: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Auth.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Auth.list_users() != [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Auth.get_user!(user.id) != user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Auth.create_user(@valid_attrs)
      assert Comeonin.Bcrypt.check_pass("123456789", user.password)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Auth.update_user(user, @update_attrs)
      assert %User{} = user
      assert Comeonin.Bcrypt.check_pass("123123123", user.password)
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Auth.update_user(user, @invalid_attrs)
      assert user != Auth.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Auth.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Auth.change_user(user)
    end

  end
end
