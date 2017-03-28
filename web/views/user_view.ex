defmodule Goncord.UserView do
  use Goncord.Web, :view

  def render("index.json", %{users: users}) do
    render_many(users, Goncord.UserView, "user.json")
  end

  def render("show.json", %{user: user}) do
    render_one(user, Goncord.UserView, "user.json")
  end

  def render("user.json", %{user: user}) do
    %{login: user.login,
      email: user.email,
      first_name: user.first_name,
      last_name: user.last_name,
      second_name: user.second_name,
      birthday: user.birthday,
      roles: Goncord.RoleView.render("index.json", %{roles: user.roles}),
      apps: Goncord.User.get_payloads(user)
    }
  end
end
