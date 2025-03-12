# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Lysh.Repo.insert!(%Lysh.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Lysh.Accounts.register_user(%{
  name: "Mister User",
  email: "mister_user@lysh.io",
  password: "my_long_password"
})

Lysh.Accounts.register_user(%{
  name: "Miss User",
  email: "miss_user@lysh.io",
  password: "my_long_password"
})
