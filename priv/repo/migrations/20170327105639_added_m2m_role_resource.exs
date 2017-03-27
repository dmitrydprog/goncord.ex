defmodule Goncord.Repo.Migrations.AddedM2mRoleResource do
  use Ecto.Migration

  def change do
    create table(:roles_resources, primary_key: false) do
      add :role_id, references(:roles)
      add :resource_id, references(:resources)
    end
  end
end
