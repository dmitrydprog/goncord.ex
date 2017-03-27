defmodule Mix.Tasks.AddRoles do
  use Mix.Task
  import Mix.Ecto
  alias Goncord.{Role, Repo}

  def run(roles) do
    ensure_started(Repo, [])

    Enum.each(roles, &{Role.get_or_create(%{name: &1})})
  end
end