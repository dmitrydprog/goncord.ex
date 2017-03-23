defmodule Goncord.Role do
  @moduledoc false

  use Goncord.Web, :model

  schema "roles" do
    field :name, :string

    many_to_many :users, Goncord.User, join_through: "users_roles", on_delete: :delete_all

    timestamps()
  end
end