defmodule LyshWeb.UrlRedirectController do
  use LyshWeb, :controller

  alias Lysh.Shortner

  def index(conn, %{"hash" => hash}) do
    original_url = Shortner.get_original_url!(hash)
    redirect(conn, external: original_url)
  end
end
