defmodule Goncord.Repo.Migrations.CreateResource do
  use Ecto.Migration

  def change do
    create table(:resources) do
      add :token, :uuid
      add :is_super, :boolean, default: false, null: false
      add :url, :string
      add :name, :string

      timestamps()
    end
    create unique_index(:resources, [:token])

  end
end
