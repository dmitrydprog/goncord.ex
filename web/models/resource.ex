defmodule Goncord.Resource do
  use Goncord.Web, :model

  schema "resources" do
    field :token, Ecto.UUID
    field :is_super, :boolean, default: false
    field :url, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:token, :is_super, :url])
    |> validate_required([:token, :is_super, :url])
    |> unique_constraint(:token)
  end

  def generate_uuid() do
    Ecto.UUID.generate()
  end
end
