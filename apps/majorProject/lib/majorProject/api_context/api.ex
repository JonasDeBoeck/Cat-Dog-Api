defmodule MajorProject.ApiContext.Api do
  use Ecto.Schema
  import Ecto.Changeset

  alias MajorProject.UserContext.User

  schema "api" do
    field :key, :string
    field :name, :string
    belongs_to :user, User
  end

  @doc false
  def changeset(api, attrs) do
    api
    |> cast(attrs, [:key, :name])
    |> validate_required([:key, :name])
  end

  def create_changeset(api, attrs, user) do
    api
    |> cast(attrs, [:key, :name])
    |> validate_required([:key, :name])
    |> put_assoc(:user, user)
  end
end
