defmodule Goncord.RoleView do
  use Goncord.Web, :view

  def render("index.json", %{roles: roles}) do
    render_many(roles, Goncord.RoleView, "role.json")
  end

  def render("role.json", %{role: role}) do
    %{name: role.name}
  end
end