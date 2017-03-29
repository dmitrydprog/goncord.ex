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
    # TODO: Update resource payloads

    user = Guardian.Plug.current_resource(conn)

    resource = conn.assigns[:resource]

    {user, user_params} =
      case resource do
        nil -> {user, user_params}

        resource ->
          case resource.is_super do
            true -> user |> extract_roles(user_params) |> extract_apps()
            _ -> {user, user_params}
          end
      end

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

  defp extract_apps({user, params}) do
    {apps, user_params} = Access.pop(params, "apps")
    Enum.each(apps, fn({k, v}) ->
      resource = Goncord.Repo.get_by(Goncord.Resource, url: k)
      Goncord.UserResource.update_payload(user, resource, v)
    end)

    {user, user_params}
  end

  defp extract_roles(user, params) do
    {roles, user_params} = Access.pop(params, "roles")
    roles = Enum.map(roles, &%{name: &1["name"]})
            |> Enum.map(&Goncord.Role.get_or_create(&1))

    {Goncord.Role.set_roles(user, roles), user_params}
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
