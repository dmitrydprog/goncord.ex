defmodule Goncord.Repo.Migrations.UserResourceM2m do
  use Ecto.Migration

  def change do
    create table(:users_resources) do
      add :user_id, references(:users)
      add :resource_id, references(:resources)
      add :payload, :map

      timestamps()
    end
  end
end
