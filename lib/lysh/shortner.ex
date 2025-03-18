defmodule Lysh.Shortner do
  @moduledoc """
  The Shortner context.
  """

  import Ecto.Query, warn: false
  alias Lysh.Repo

  alias Lysh.Shortner.Link

  @doc """
  Returns the list of shortened_links.

  ## Examples

      iex> list_shortened_links()
      [%Link{}, ...]

  """
  def list_shortened_links, do: list_shortened_links([])

  def list_shortened_links(criteria) do
    query = from(l in Link)

    criteria
    |> apply_criteria(query)
    |> Repo.all()
  end

  defp apply_criteria(criteria, base_query) do
    Enum.reduce(criteria, base_query, fn
      {:user, user}, query ->
        from l in query, where: l.user_id == ^user.id

      {:preload, bindings}, query ->
        preload(query, ^bindings)

      _, query ->
        query
    end)
  end

  @doc """
  Gets a single link.

  Raises `Ecto.NoResultsError` if the Link does not exist.

  ## Examples

      iex> get_link!(123)
      %Link{}

      iex> get_link!(456)
      ** (Ecto.NoResultsError)

  """
  def get_link!(id), do: Repo.get!(Link, id)

  def get_original_url(hash) do
    query =
      from Link,
        where: [hash_url: ^hash],
        select: [:original_url]

    case Repo.one(query) do
      nil -> nil
      link -> Map.get(link, :original_url)
    end
  end

  @doc """
  Creates a link.

  ## Examples

      iex> create_link(%{field: value})
      {:ok, %Link{}}

      iex> create_link(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_link(attrs \\ %{}) do
    %Link{}
    |> Link.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a link.

  ## Examples

      iex> update_link(link, %{field: new_value})
      {:ok, %Link{}}

      iex> update_link(link, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_link(%Link{} = link, attrs) do
    link
    |> Link.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a link.

  ## Examples

      iex> delete_link(link)
      {:ok, %Link{}}

      iex> delete_link(link)
      {:error, %Ecto.Changeset{}}

  """
  def delete_link(%Link{} = link) do
    Repo.delete(link)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking link changes.

  ## Examples

      iex> change_link(link)
      %Ecto.Changeset{data: %Link{}}

  """
  def change_link(%Link{} = link, attrs \\ %{}) do
    Link.changeset(link, attrs)
  end
end
