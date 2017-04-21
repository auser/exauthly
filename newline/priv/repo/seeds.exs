# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Newline.Repo.insert!(%Newline.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
ari = Newline.User.signup_changeset(%Newline.User{}, %{
  email: "ari@fullstack.io",
  password: System.get_env("PASS") || "s3cr3t",
  admin: true
})
|> Newline.Repo.insert!

ari = Newline.User.update_changeset(ari, %{admin: true})
Newline.Repo.update!(ari)