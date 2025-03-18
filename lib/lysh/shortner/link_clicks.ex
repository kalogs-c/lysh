defmodule Lysh.Shortner.LinkClicks do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "link_clicks" do
    field :os, :string
    field :clicket_at, :utc_datetime
    field :ip_address, :string
    field :user_agent, :string
    field :referrer, :string
    field :country_code, :string
    field :browser, :string
    field :utm_source, :string
    belongs_to :link, Lysh.Shortner.Link
  end

  @doc false
  def changeset(shortner, attrs) do
    shortner
    |> cast(attrs, [
      :clicket_at,
      :ip_address,
      :user_agent,
      :referrer,
      :country_code,
      :browser,
      :os,
      :utm_source,
      :link_id
    ])
    |> validate_required([
      :clicket_at,
      :ip_address,
      :user_agent,
      :referrer,
      :country_code,
      :browser,
      :os,
      :utm_source,
      :link_id
    ])
  end
end
