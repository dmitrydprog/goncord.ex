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

    field :password, :string, virtual: true

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:login, :password, :hashed_password, :email, :first_name, :last_name, :second_name, :birthday])
    |> unique_constraint(:login)
    |> unique_constraint(:email)
    |> validate_required([:login, :password, :email])
    |> validate_length(:password, min: 6)
    |> validate_length(:login, min: 3)
    |> validate_format(:email, ~r/\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}\b/i)
    |> hash_password()
  end

  def check_hashed_password(user, password) do
    case user do
      nil -> false
      _   -> Comeonin.Bcrypt.checkpw(password, user.hashed_password)
    end
  end

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :hashed_password, Comeonin.Bcrypt.hashpwsalt(password))
      _ -> changeset
    end
  end
end