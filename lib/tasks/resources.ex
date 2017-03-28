defmodule Mix.Tasks.AddResource do
  use Mix.Task
  import Mix.Ecto
  alias Goncord.{Role, Resource, Repo}

  def run(blob_resource) do
    ensure_started(Goncord.Repo, [])
    add_resource(blob_resource)
  end

  defp add_resource(["super", url, name | roles]) do
    add_resource(%{is_super: true, name: name, url: url}, roles)
  end

  defp add_resource([url, name | roles]) do
    add_resource(%{is_super: false, name: name, url: url}, roles)
  end

  defp add_resource(params, roles) do
    roles = Enum.map roles, fn name ->
      Role.get_or_create(%{name: name})
    end

    resource = Resource.get_or_create(params)
    Goncord.Role.set_roles(resource, roles)

    case resource.is_super do
      true ->
        IO.puts("Generate resource with SUPER status!")
      _ ->
        IO.puts("Generate new resource!")
    end

    IO.puts("Token: " <> resource.token)
  end
end