defmodule Goncord.TokenView do
  use Goncord.Web, :view

  alias Goncord.UserView

  def render("show.json", %{jwt: jwt, user: user}) do
    %{
      jwt: jwt,
      user: UserView.render("user.json", user: user)
    }
  end

  def render("error.json", %{message: message}) do
    %{error: message}
  end
end