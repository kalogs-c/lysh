defmodule Lysh.Shortner.Link do
  use Ecto.Schema
  import Ecto.Changeset

  alias Lysh.Repo
  alias Lysh.Base62

  @hash_length 8

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
    |> cast(attrs, [:original_url, :user_id])
    |> validate_required([:original_url, :user_id])
    |> maybe_add_http()
    |> maybe_hash_url()
    |> unique_constraint(:hash_url)
  end

  defp maybe_add_http(%Ecto.Changeset{} = changeset) do
    if url = get_change(changeset, :original_url) do
      changeset
      |> put_change(:original_url, maybe_add_http(url))
    else
      changeset
    end
  end

  defp maybe_add_http("http" <> _after_http = original_url), do: original_url
  defp maybe_add_http(without_http), do: "http://" <> without_http

  defp maybe_hash_url(changeset) do
    if original_url = get_change(changeset, :original_url) do
      maybe_apply_hash(changeset, original_url)
    else
      changeset
    end
  end

  defp maybe_apply_hash(changeset, original_url) do
    if changeset.data.hash_url == nil do
      changeset
      |> put_change(:hash_url, hash_url(original_url))
    else
      changeset
    end
  end

  defp hash_url(url) do
    entire_hash = :crypto.hash(:sha256, url)
    hash_url(entire_hash, 0)
  end

  defp hash_url(hashed_url, start) do
    hash =
      hashed_url
      |> binary_part(start, @hash_length)
      |> :binary.decode_unsigned()
      |> Base62.encode()

    case unique_hash?(hash) do
      true -> hash
      false -> hash_url(hashed_url, start + 1)
    end
  end

  defp unique_hash?(hash) do
    case Repo.get_by(Lysh.Shortner.Link, hash_url: hash) do
      nil -> true
      _url -> false
    end
  end
end
