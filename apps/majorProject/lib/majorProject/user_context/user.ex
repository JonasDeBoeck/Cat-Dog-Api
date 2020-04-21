defmodule MajorProject.UserContext.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias MajorProject.AnimalContext.Animal

  @acceptable_roles ["Admin", "User"]

  schema "users" do
    field :password, :string, virtual: true
    field :hashed_password, :string
    field :role, :string
    field :username, :string
    has_many :animals, Animal
  end

  def get_acceptable_roles, do: @acceptable_roles

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :role])
    |> unique_constraint(:username)
    |> validate_required([:username, :password, :role])
    |> validate_inclusion(:role, @acceptable_roles)
    |> put_password_hash()
  end

  defp put_password_hash(
    %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
  ) do
    change(changeset, hashed_password: Pbkdf2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
