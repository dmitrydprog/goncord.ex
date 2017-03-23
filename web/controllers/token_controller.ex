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
end