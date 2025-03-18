defmodule LyshWeb.UrlRedirectController do
  use LyshWeb, :controller

  alias Lysh.Shortner

  def index(conn, %{"hash" => hash}) do
    case Shortner.get_original_url(hash) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(LyshWeb.ErrorHTML)
        |> render(:"404", %{})
        |> halt

      original_url ->
        redirect(conn, external: original_url)
    end
  end
end
