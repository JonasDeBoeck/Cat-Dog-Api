defmodule MajorProject.AnimalContext.Animal do
  use Ecto.Schema
  import Ecto.Changeset

  alias MajorProject.UserContext.User

  schema "animals" do
    field :date_of_birth, :date
    field :name, :string
    field :type, :string
    belongs_to :user, User
  end

  @doc false
  def changeset(animal, attrs) do
    animal
    |> cast(attrs, [:name, :date_of_birth, :type])
    |> validate_required([:name, :date_of_birth, :type])
  end

    @doc false
    def create_changeset(animal, attrs, user) do
      animal
      |> cast(attrs, [:name, :date_of_birth, :type])
      |> validate_required([:name, :date_of_birth, :type])
      |> put_assoc(:user, user)
    end
end
