defmodule LyshWeb.LinkLiveTest do
  use LyshWeb.ConnCase

  import Phoenix.LiveViewTest
  import Lysh.ShortnerFixtures

  @create_attrs %{original_url: "some original_url"}
  @update_attrs %{original_url: "some updated original_url"}
  @invalid_attrs %{original_url: nil}

  defp login(%{conn: conn}) do
    user = Lysh.AccountsFixtures.user_fixture()
    %{conn: log_in_user(conn, user), user: user}
  end

  defp create_link(%{user: user} = context) do
    link = link_fixture(user_id: user.id)
    Map.put_new(context, :link, link)
  end

  describe "Index" do
    setup [:login, :create_link]

    test "lists all shortened_links", %{conn: conn, link: link} do
      {:ok, _index_live, html} = live(conn, ~p"/shortened_links")

      assert html =~ "Listing Shortened links"
      assert html =~ link.original_url
    end

    test "saves new link", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/shortened_links")

      assert index_live |> element("a", "New Link") |> render_click() =~
               "New Link"

      assert_patch(index_live, ~p"/shortened_links/new")

      assert index_live
             |> form("#link-form", link: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#link-form", link: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/shortened_links")

      html = render(index_live)
      assert html =~ "Link created successfully"
      assert html =~ "some original_url"
    end

    test "updates link in listing", %{conn: conn, link: link} do
      {:ok, index_live, _html} = live(conn, ~p"/shortened_links")

      assert index_live |> element("#shortened_links-#{link.id} a", "Edit") |> render_click() =~
               "Edit Link"

      assert_patch(index_live, ~p"/shortened_links/#{link}/edit")

      assert index_live
             |> form("#link-form", link: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#link-form", link: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/shortened_links")

      html = render(index_live)
      assert html =~ "Link updated successfully"
      assert html =~ "some updated original_url"
    end

    test "deletes link in listing", %{conn: conn, link: link} do
      {:ok, index_live, _html} = live(conn, ~p"/shortened_links")

      assert index_live |> element("#shortened_links-#{link.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#shortened_links-#{link.id}")
    end
  end

  describe "Show" do
    setup [:login, :create_link]

    test "displays link", %{conn: conn, link: link} do
      {:ok, _show_live, html} = live(conn, ~p"/shortened_links/#{link}")

      assert html =~ "Show Link"
      assert html =~ link.original_url
    end

    test "updates link within modal", %{conn: conn, link: link} do
      {:ok, show_live, _html} = live(conn, ~p"/shortened_links/#{link}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Link"

      assert_patch(show_live, ~p"/shortened_links/#{link}/show/edit")

      assert show_live
             |> form("#link-form", link: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#link-form", link: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/shortened_links/#{link}")

      html = render(show_live)
      assert html =~ "Link updated successfully"
      assert html =~ "some updated original_url"
    end
  end
end
