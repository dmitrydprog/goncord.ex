defmodule Goncord.UserResource do
  use Ecto.Schema
  import Ecto.Query

  schema "users_resources" do
    belongs_to :user, Goncord.User
    belongs_to :resource, Goncord.Resource
    field :payload, :map

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, [:user_id, :resource_id, :payload])
    |> Ecto.Changeset.validate_required([:user_id, :resource_id, :payload])
  end

  def create(params) do
    changeset = changeset %Goncord.UserResource{}, params
    Goncord.Repo.insert! changeset
  end

  def get_or_create(user, resource, payload) do
    params = %{user_id: user.id, resource_id: resource.id, payload: payload}
    query = from ur in Goncord.UserResource,
            where: ur.user_id == ^user.id and ur.resource_id == ^resource.id

    Goncord.Repo.one query || create params
  end

  def update_payload(user, resource, payload) do
    user_resource = Goncord.UserResource.get_or_create user, resource, payload

    case user_resource do
      nil -> nil

      user_resource ->
        changeset = changeset user_resource, %{payload: payload}
        Goncord.Repo.update! changeset
    end
  end
end