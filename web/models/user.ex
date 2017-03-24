defmodule Goncord.User do
  use Goncord.Web, :model

  schema "users" do
    field :login, :string
    field :hashed_password, :string
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :second_name, :string
    field :birthday, Ecto.Date

    many_to_many :roles, Goncord.Role, join_through: "users_roles", on_delete: :delete_all

    field :password, :string, virtual: true

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> Goncord.Repo.preload(:roles)
    |> cast(params, [:login, :password, :hashed_password, :email, :first_name, :last_name, :second_name, :birthday])
    |> cast_assoc(:roles)
    |> custom_unique_fields()
    |> validate_required([:login, :password, :email])
    |> custom_validate_fields()
    |> hash_password()
  end

  def update(struct, params \\ %{}) do
    struct
    |> cast(params, [:first_name, :last_name, :second_name, :birthday])
    |> custom_unique_fields()
    |> custom_validate_fields()
  end

  def check_hashed_password(user, password) do
    case user do
      nil -> false
      _   -> Comeonin.Bcrypt.checkpw(password, user.hashed_password)
    end
  end

  def change_password(user, old_password, new_password) do
    case check_hashed_password(user, old_password) do
      true ->
        changeset = changeset(user, %{password: new_password})
        changeset = hash_password(changeset)
        case Goncord.Repo.update(changeset) do
          {:ok, _} -> true
          _ -> false
        end

      _ -> false
    end
  end

  defp custom_validate_fields(struct) do
    struct
    |> validate_length(:password, min: 6)
    |> validate_length(:login, min: 3)
    |> validate_format(:email, ~r/\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}\b/i)
  end

  defp custom_unique_fields(struct) do
    struct
    |> unique_constraint(:login)
    |> unique_constraint(:email)
  end

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :hashed_password, Comeonin.Bcrypt.hashpwsalt(password))
      _ -> changeset
    end
  end
end