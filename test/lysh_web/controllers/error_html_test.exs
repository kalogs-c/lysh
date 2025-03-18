defmodule LyshWeb.ErrorHTMLTest do
  use LyshWeb.ConnCase, async: true

  # Bring render_to_string/4 for testing custom views
  import Phoenix.Template

  test "renders 404.html" do
    assert render_to_string(LyshWeb.ErrorHTML, "404", "html", []) =~
             "Sorry, the link you are looking for does not exist."
  end

  test "renders 500.html" do
    assert render_to_string(LyshWeb.ErrorHTML, "500", "html", []) == "Internal Server Error"
  end
end
