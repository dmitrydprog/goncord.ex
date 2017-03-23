defmodule Mix.Tasks.AddRoles do
  use Mix.Task
  import Mix.Ecto
  alias Goncord.{Role, Repo}

  def run(roles) do
    ensure_started(Goncord.Repo, [])

    Enum.each(roles, &{add_role(&1)})
  end

  defp add_role(role) do
    changeset = Role.changeset(%Role{}, %{name: role})
    role = Repo.insert!(changeset)

    IO.inspect(role)
  end
end