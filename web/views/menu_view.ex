defmodule Goncord.MenuView do
  use Goncord.Web, :view

  def render("menu.json", %{urls: urls}) do
    %{
      menu: render_many(urls, Goncord.MenuView, "url.json")
    }
  end

  def render("url.json", %{menu: resource}) do
    %{
      url: resource.url,
      name: resource.name
    }
  end
end