defmodule Goncord.RoleController do
  use Goncord.Web, :controller

  def add_role(conn, %{"roles" => roles}) do
    user = Guardian.Plug.current_resource(conn)
    resource = conn.assigns[:resource]

    if is_nil(resource) do
      conn
      |> put_status(:not_found)
      |> put_view(Goncord.TokenView)
      |> render("error.json", message: "Ресурс не существует.")
    end

    unless resource.is_super do
      conn
      |> put_status(:not_found)
      |> put_view(Goncord.TokenView)
      |> render("error.json", message: "У ресурса недостаточно прав.")
    end

    roles = Enum.map(roles, fn role ->
      Goncord.Role.get_or_create(%{name: role})
    end)

    Goncord.Role.set_roles(user, roles)

    conn
    |> put_status(:ok)
    |> put_view(Goncord.RoleView)
    |> render("index.json", %{roles: roles})
  end
end