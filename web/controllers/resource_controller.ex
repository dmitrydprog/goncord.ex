defmodule Goncord.ResourceController do
  use Goncord.Web, :controller

  def self_update(conn, params) do
    user = Guardian.Plug.current_resource conn
    resource = conn.assigns[:resource]

    Goncord.UserResource.update_payload user, resource, params

    conn
    |> put_status(:ok)
    |> put_view(Goncord.UserView)
    |> render("user.json", user: user)
  end

  def update(conn, params) do
    user = Guardian.Plug.current_resource conn
    user = extract_apps user, params

    conn
    |> put_status(:ok)
    |> put_view(Goncord.UserView)
    |> render("user.json", user: user)
  end

  defp extract_apps(user, params) do
    Enum.each(params, fn {k, v} ->
      case Goncord.Repo.get_by Goncord.Resource, url: k do
        nil -> nil
        resource -> Goncord.UserResource.update_payload user, resource, v
      end
    end)

    user
  end
end