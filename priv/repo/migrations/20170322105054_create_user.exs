defmodule Goncord.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :login, :string
      add :hashed_password, :string
      add :email, :string
      add :first_name, :string
      add :last_name, :string
      add :second_name, :string
      add :birthday, :date

      timestamps()
    end

  end
end
