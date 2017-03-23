defmodule Goncord.Role do
  @moduledoc false

  use Goncord.Web, :model

  schema "roles" do
    field :name, :string

    many_to_many :users, Goncord.User, join_through: "users_roles", on_delete: :delete_all

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> unique_constraint(:name)
    |> validate_required([:name])
  end
end