defmodule Lysh.Shortner.Link do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "shortened_links" do
    field :original_url, :string
    field :hash_url, :string
    belongs_to :user, Lysh.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:original_url, :hash_url, :user_id])
    |> validate_required([:original_url, :hash_url, :user_id])
    |> unique_constraint(:hash_url)
  end
end
