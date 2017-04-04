defmodule Goncord.Role do
  @moduledoc false

  use Goncord.Web, :model
  alias Goncord.{Role, Repo}

  schema "roles" do
    field :name, :string

    many_to_many :users, Goncord.User, join_through: "users_roles", on_delete: :delete_all
    many_to_many :resources, Goncord.Resource, join_through: "roles_resources", on_delete: :delete_all

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> unique_constraint(:name)
    |> validate_required([:name])
  end

  def create(params) do
    changeset = changeset %Role{}, params
    Repo.insert! changeset
  end

  def get_or_create(params) do
    query = from r in Goncord.Role,
        where: r.name == ^params.name

    Repo.one query || create params
  end

  def set_roles(model, roles) do
    model
    |> Goncord.Repo.preload(:roles)
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:roles, roles)
    |> Goncord.Repo.update!
  end
end