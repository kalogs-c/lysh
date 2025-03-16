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

ids =
  Enum.map(1..10, fn _ ->
    {:ok, user} =
      Lysh.Accounts.register_user(%{
        name: Faker.Person.name(),
        email: Faker.Internet.email(),
        password: "my_long_password"
      })

    user.id
  end)

for _ <- 1..1000 do
  Lysh.Shortner.create_link(%{
    original_url: Faker.Internet.url(),
    user_id: Enum.random(ids)
  })
end
