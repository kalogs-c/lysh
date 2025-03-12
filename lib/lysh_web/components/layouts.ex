defmodule LyshWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use LyshWeb, :controller` and
  `use LyshWeb, :live_view`.
  """
  use LyshWeb, :html

  embed_templates "layouts/*"
end
