defmodule Goncord.Repo.Migrations.AddManyToMany do
  use Ecto.Migration

  def change do
    create table(:users_roles, primary_key: false) do
      add :user_id, references(:users)
      add :role_id, references(:roles)
    end
  end
end
