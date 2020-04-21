# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     MajorProject.Repo.insert!(%MajorProject.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

{:ok, _cs} = MajorProject.UserContext.create_user(%{"password" => "t", "role" => "User", "username" => "user"})
{:ok, _cs} = MajorProject.UserContext.create_user(%{"password" => "t", "role" => "Admin", "username" => "admin"})