defmodule MajorProject.Repo.Migrations.CreateApi do
  use Ecto.Migration

  def change do
    create table(:api) do
      add :key, :string, null: false
      add :name, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
    end

    create index(:api, [:user_id])
  end
end
