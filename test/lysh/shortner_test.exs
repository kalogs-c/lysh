defmodule Lysh.ShortnerTest do
  use Lysh.DataCase

  alias Lysh.Shortner

  describe "shortened_links" do
    alias Lysh.Shortner.Link

    import Lysh.ShortnerFixtures

    @invalid_attrs %{original_url: nil, hash_url: nil}

    test "list_shortened_links/0 returns all shortened_links" do
      link = link_fixture()
      assert Shortner.list_shortened_links() == [link]
    end

    test "list_shortened_links/1 with user criteria" do
      user = Lysh.AccountsFixtures.user_fixture()
      link = link_fixture(user_id: user.id)

      _other_link = link_fixture()

      assert Shortner.list_shortened_links(user: user) == [link]
    end

    test "get_link!/1 returns the link with given id" do
      link = link_fixture()
      assert Shortner.get_link!(link.id) == link
    end

    test "get_original_url/1 return the original link with given hash" do
      link = link_fixture()
      assert Shortner.get_original_url(link.hash_url) == link.original_url
    end

    test "get_original_url/1 return nil with non existant link" do
      assert Shortner.get_original_url("fake-hash") == nil
    end

    test "create_link/1 with valid data creates a link" do
      user = Lysh.AccountsFixtures.user_fixture()
      url = Faker.Internet.url()

      valid_attrs = %{
        original_url: url,
        user_id: user.id
      }

      assert {:ok, %Link{} = link} = Shortner.create_link(valid_attrs)
      assert link.original_url == url
      assert link.hash_url
    end

    test "create_link/1 with valid data creates a link and add http to original url" do
      user = Lysh.AccountsFixtures.user_fixture()

      valid_attrs = %{
        original_url: "lysh.io",
        user_id: user.id
      }

      assert {:ok, %Link{} = link} = Shortner.create_link(valid_attrs)
      assert link.original_url == "http://lysh.io"
      assert link.hash_url
    end

    test "create_link/1 with hash collision" do
      user = Lysh.AccountsFixtures.user_fixture()

      valid_attrs = %{
        original_url: Faker.Internet.url(),
        user_id: user.id
      }

      {:ok, first_link} = Shortner.create_link(valid_attrs)
      {:ok, second_link} = Shortner.create_link(valid_attrs)

      assert first_link.original_url == second_link.original_url
      assert first_link.hash_url != second_link.hash_url
    end

    test "create_link/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Shortner.create_link(@invalid_attrs)
    end

    test "update_link/2 with valid data updates the link" do
      link = link_fixture()

      update_attrs = %{
        original_url: "https://lysh.io"
      }

      assert {:ok, %Link{} = updated_link} = Shortner.update_link(link, update_attrs)
      assert updated_link.original_url == "https://lysh.io"
      assert updated_link.hash_url == link.hash_url
    end

    test "update_link/2 with invalid data returns error changeset" do
      link = link_fixture()
      assert {:error, %Ecto.Changeset{}} = Shortner.update_link(link, @invalid_attrs)
      assert link == Shortner.get_link!(link.id)
    end

    test "delete_link/1 deletes the link" do
      link = link_fixture()
      assert {:ok, %Link{}} = Shortner.delete_link(link)
      assert_raise Ecto.NoResultsError, fn -> Shortner.get_link!(link.id) end
    end

    test "change_link/1 returns a link changeset" do
      link = link_fixture()
      assert %Ecto.Changeset{} = Shortner.change_link(link)
    end
  end
end
