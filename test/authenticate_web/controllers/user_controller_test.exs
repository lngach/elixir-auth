defmodule AuthenticateWeb.UserControllerTest do
  use AuthenticateWeb.ConnCase

  alias Authenticate.Auth
  alias Authenticate.Auth.User

  @create_attrs %{confirmation_sent_at: ~N[2010-04-17 14:00:00.000000], confirmation_token: Faker.String.base64(20), confirmed_at: ~N[2010-04-17 14:00:00.000000], current_sign_in_at: ~N[2010-04-17 14:00:00.000000], current_sign_in_ip: "192.168.0.101", disable: false, email: Faker.Internet.safe_email(), failed_attempts: 42, image: Faker.Avatar.image_url(), last_sign_in_at: ~N[2010-04-17 14:00:00.000000], last_sign_in_ip: "192.168.0.103", locked_at: ~N[2010-04-17 14:00:00.000000], name: Faker.Name.name(), password: "123456789", provider: Faker.Internet.safe_email(), reset_password_sent_at: ~N[2010-04-17 14:00:00.000000], reset_password_token: Faker.String.base64(20), sign_in_count: 123, tokens: Faker.String.base64(20), uid: Faker.UUID.v4(), username: Faker.Internet.user_name()}
  @update_attrs %{confirmation_sent_at: ~N[2010-04-17 14:00:00.000000], confirmation_token: Faker.String.base64(20), confirmed_at: ~N[2010-04-17 14:00:00.000000], current_sign_in_at: ~N[2010-04-17 14:00:00.000000], current_sign_in_ip: "192.168.0.101", disable: false, email: Faker.Internet.safe_email(), failed_attempts: 42, image: Faker.Avatar.image_url(), last_sign_in_at: ~N[2010-04-17 14:00:00.000000], last_sign_in_ip: "192.168.0.103", locked_at: ~N[2010-04-17 14:00:00.000000], name: Faker.Name.name(), password: "123123123", provider: Faker.Internet.safe_email(), reset_password_sent_at: ~N[2010-04-17 14:00:00.000000], reset_password_token: Faker.String.base64(20), sign_in_count: 123, tokens: Faker.String.base64(20), uid: Faker.UUID.v4(), username: Faker.Internet.user_name()}
  @invalid_attrs %{confirmation_sent_at: nil, confirmation_token: nil, confirmed_at: nil, current_sign_in_at: nil, current_sign_in_ip: nil, disable: nil, email: nil, failed_attempts: nil, image: nil, last_sign_in_at: nil, last_sign_in_ip: nil, locked_at: nil, name: nil, password: nil, provider: nil, reset_password_token: nil, reset_password_sent_at: nil, sign_in_count: nil, tokens: nil, uid: nil, username: nil}

  def fixture(:user) do
    {:ok, user} = Auth.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get conn, user_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, user_path(conn, :show, id)
      assert json_response(conn, 200)["data"] != %{
        "id" => id}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put conn, user_path(conn, :update, user), user: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, user_path(conn, :show, id)
      assert json_response(conn, 200)["data"] != %{
        "id" => id}
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete conn, user_path(conn, :delete, user)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, user_path(conn, :show, user)
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
