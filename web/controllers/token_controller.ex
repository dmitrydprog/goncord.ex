defmodule Goncord.TokenController do
  use Goncord.Web, :controller
  require Logger

  alias Goncord.User

  def create(conn, %{"login" => login, "password" => password}) do
    user = Repo.get_by(User, login: login)
    create(conn, user, password)
  end

  def create(conn, %{"email" => email, "password" => password}) do
    user = Repo.get_by(User, email: email)
    create(conn, user, password)
  end

  defp create(conn, user, password) do
    case User.check_hashed_password(user, password) do
      true ->
        case Guardian.encode_and_sign(user, :token, %{}) do
          {:ok, jwt, _full_claims} ->
            conn
            |> put_status(:created)
            |> render("show.json", jwt: jwt, user: user)
          {:error, reason} ->
            Logger.error("Error in #{__MODULE__}.create. Tried to issue JWT: #{inspect(reason)}")
            send_resp(conn, :internal_server_error, "")
        end
      _ ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", message: "Проверьте правильность логина, email или пароля")
    end
  end

  def delete(conn, _params) do
    jwt = Guardian.Plug.current_token(conn)
    {:ok, claims} = Guardian.Plug.claims(conn)

    case Guardian.revoke!(jwt, claims, nil) do
      :ok -> send_resp(conn, :no_content, "")
      {:error, reason} ->
        Logger.error("Error in #{__MODULE__}.delete. Tried to revoke JWT: #{inspect(reason)}")
        send_resp(conn, :internal_server_error, "")
    end
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(:unauthorized)
    |> put_view(Goncord.TokenView)
    |> render("error.json", message: "Требуется аутентификация")
  end

  def validate(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    conn
    |> put_status(:ok)
    |> put_view(Goncord.UserView)
    |> render("user.json", user: user)
  end
end