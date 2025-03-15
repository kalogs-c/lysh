defmodule Lysh.ShortnerFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lysh.Shortner` context.
  """

  @doc """
  Generate a link.
  """
  def link_fixture(attrs \\ %{}) do
    user = Lysh.AccountsFixtures.user_fixture()

    {:ok, link} =
      attrs
      |> Enum.into(%{
        original_url: Faker.Internet.url(),
        user_id: user.id
      })
      |> Lysh.Shortner.create_link()

    link
  end
end
