defmodule Goncord.MenuController do
  use Goncord.Web, :controller

  def get_menu(conn, _parmas) do
    user = Guardian.Plug.current_resource(conn)

    urls = user.roles
    |> Enum.reduce([], fn (role, acc) ->
      role = role
      |> Goncord.Repo.preload(:resources)

      acc ++ role.resources
    end)

    conn
    |> put_status(:ok)
    |> put_view(Goncord.MenuView)
    |> render("menu.json", %{urls: urls})
  end
end