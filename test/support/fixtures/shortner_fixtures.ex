defmodule Lysh.ShortnerFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lysh.Shortner` context.
  """

  @doc """
  Generate a unique link hash_url.
  """
  def unique_link_hash_url, do: "some hash_url#{System.unique_integer([:positive])}"

  @doc """
  Generate a link.
  """
  def link_fixture(attrs \\ %{}) do
    user = Lysh.AccountsFixtures.user_fixture()

    {:ok, link} =
      attrs
      |> Enum.into(%{
        hash_url: unique_link_hash_url(),
        original_url: "some original_url",
        user_id: user.id
      })
      |> Lysh.Shortner.create_link()

    link
  end
end
