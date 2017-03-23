defmodule Goncord.UserView do
  use Goncord.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, Goncord.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, Goncord.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{login: user.login,
      email: user.email,
      first_name: user.first_name,
      last_name: user.last_name,
      second_name: user.second_name,
      birthday: user.birthday}
  end
end
