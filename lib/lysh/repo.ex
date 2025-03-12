defmodule Lysh.Repo do
  use Ecto.Repo,
    otp_app: :lysh,
    adapter: Ecto.Adapters.Postgres
end
