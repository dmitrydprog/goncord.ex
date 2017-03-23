defmodule Goncord.UserController do
  use Goncord.Web, :controller

  alias Goncord.User

  def create(conn, user_params) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", user_path(conn, :show, user))
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
end
