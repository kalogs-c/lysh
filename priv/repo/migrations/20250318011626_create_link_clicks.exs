defmodule Lysh.Repo.Migrations.CreateLinkClicks do
  use Ecto.Migration

  def change do
    create table(:link_clicks, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :clicket_at, :utc_datetime, default: fragment("now()")
      add :ip_address, :string
      add :user_agent, :text
      add :referrer, :text
      add :country_code, :string, size: 2
      add :browser, :string
      add :os, :string
      add :utm_source, :string
      add :link_id, references(:shortened_links, on_delete: :delete_all, type: :binary_id)
    end

    create index(:link_clicks, [:link_id])
  end
end
