defmodule Mix.Tasks.AddResource do
  use Mix.Task
  import Mix.Ecto
  alias Goncord.{Role, Resource, Repo}

  def run(blob_resource) do
    ensure_started(Goncord.Repo, [])
    add_resource(blob_resource)
  end

  defp add_resource(["super", url]) do
    add_resource(%{is_super: true, url: url})
  end

  defp add_resource([url]) do
    add_resource(%{is_super: false, url: url})
  end

  defp add_resource(params) do
    uuid = Resource.generate_uuid()
    params = Dict.put(params, :token, uuid)

    changeset = Resource.changeset(%Resource{}, params)
    resource = Repo.insert!(changeset)

    case resource.is_super do
      true ->
        IO.puts("Generate resource with SUPER status!")
      _ ->
        IO.puts("Generate new resource!")
    end

    IO.puts("Token: " <> resource.token)
  end
end