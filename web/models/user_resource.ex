defmodule Goncord.UserResource do
  use Ecto.Schema

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
end