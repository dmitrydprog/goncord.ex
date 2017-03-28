defmodule Goncord.Resource do
  use Goncord.Web, :model

  schema "resources" do
    field :token, Ecto.UUID
    field :is_super, :boolean, default: false
    field :url, :string
    field :name, :string

    many_to_many :roles, Goncord.Role, join_through: "roles_resources", on_delete: :delete_all, on_replace: :delete
    many_to_many :users, Goncord.User, join_through: Goncord.UserResource, on_delete: :delete_all

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:token, :is_super, :url, :name])
    |> validate_required([:token, :is_super, :url, :name])
    |> unique_constraint(:token)
  end

  def generate_uuid() do
    Ecto.UUID.generate()
  end

  def create(params) do
    uuid = generate_uuid()
    params = Map.put(params, :token, uuid)

    changeset = changeset(%Goncord.Resource{}, params)
    Goncord.Repo.insert!(changeset)
  end

  def get_or_create(params) do
    query = from r in Goncord.Resource,
            where: r.url == ^params.url

    Goncord.Repo.one(query) || create(params)
  end
end
