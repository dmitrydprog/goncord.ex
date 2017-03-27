defmodule Goncord.UserController do
  use Goncord.Web, :controller

  alias Goncord.User

  def create(conn, user_params) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render("show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Goncord.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def update(conn, user_params) do
    user = Guardian.Plug.current_resource(conn)
    changeset = User.update(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        render(conn, "show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Goncord.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def change_password(conn, %{"old_password" => old, "new_password" => new}) do
    user = Guardian.Plug.current_resource(conn)
    case User.change_password(user, old, new) do
      true -> send_resp(conn, :ok, "")
      _ -> conn
           |> put_status(:unprocessable_entity)
           |> put_view(Goncord.TokenView)
           |> render("error.json", message: "Не удалось поменять пароль")
    end
  end
end
