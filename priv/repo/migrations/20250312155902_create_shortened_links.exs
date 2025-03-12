defmodule Lysh.Repo.Migrations.CreateShortenedLinks do
  use Ecto.Migration

  def change do
    create table(:shortened_links, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :original_url, :text
      add :hash_url, :string
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:shortened_links, [:hash_url])
    create index(:shortened_links, [:user_id])
  end
end
