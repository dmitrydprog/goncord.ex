defmodule Goncord.RoleController do
  use Goncord.Web, :controller

  def add_role(conn, %{"roles" => roles}) do
    user = Guardian.Plug.current_resource conn

    roles = Enum.map(roles, fn role ->
      Goncord.Role.get_or_create %{name: role}
    end)

    Goncord.Role.set_roles user, roles

    conn
    |> put_status(:ok)
    |> put_view(Goncord.RoleView)
    |> render("index.json", %{roles: roles})
  end

  def delete_role(conn, %{"roles" => roles}) do
    user = Guardian.Plug.current_resource conn
    related_roles = Goncord.User.get_all_related_roles user
                    |> Enum.map(fn role -> role.name end)

    new_roles = related_roles -- roles
                |> Enum.map(fn role -> %{name: role} end)

    new_roles = new_roles
                |> Enum.map(fn role -> Goncord.Role.get_or_create role end)

    Goncord.Role.set_roles user, new_roles

    conn
    |> send_resp(:no_content, "")
  end
end