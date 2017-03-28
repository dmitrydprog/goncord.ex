defmodule Goncord.UserResourceView do
  use Goncord.Web, :view

  def render("index.json", %{resources: resources}) do
    IO.inspect(resources)

    render_many(resources, Goncord.UserResourceView, "show.json")
  end

  def render("show.json", %{resource: resource}) do
    render_one(resource, Goncord.UserResourceView, "resource.json")
  end

  def render("resource.json", %{resource: resource}) do
    %{
        pyaload: resource.payload
    }
  end
end