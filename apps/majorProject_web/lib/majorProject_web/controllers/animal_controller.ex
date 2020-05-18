defmodule MajorProjectWeb.AnimalController do
    use MajorProjectWeb, :controller

    alias MajorProject.AnimalContext
    alias MajorProject.AnimalContext.Animal
    alias MajorProject.UserContext
    alias MajorProject.UserContext.User
    alias MajorProject.ApiContext

    def index(conn, %{"user_id" => user_id}) do
        if authorisation(conn, user_id) do
          user = UserContext.get_user!(user_id)
          user_with_loaded_animals = AnimalContext.load_animals(user)
          render(conn, "index.json", animals: user_with_loaded_animals.animals)
        else
          conn
          |>send_resp(401, "Unauthorized")
        end
    end

    def create(conn, %{"user_id" => user_id, "animal" => animal_params}) do
      if authorisation(conn, user_id) do
        user = UserContext.get_user!(user_id)
        case AnimalContext.create_animal(animal_params, user) do
          {:ok, %Animal{} = animal} ->
            conn
            |> put_status(:created)
            |> put_resp_header("location", Routes.user_animal_path(conn, :show, user_id, animal))
            |> render("details.json", animal: animal)

          {:error, _cs} ->
            conn
            |> send_resp(400, "Something went wrong, sorry. Adjust your parameters or give up.")
        end
      else
        conn
        |>send_resp(401, "Unauthorized")
      end
    end

    def show(conn, %{"id" => id, "user_id" => user_id}) do
      if authorisation(conn, user_id) do
        animal = AnimalContext.get_animal!(id)
        render(conn, "show.json", animal: animal)
      else
        conn
        |>send_resp(401, "Unauthorized")
    end
  end

    def show_details(conn, %{"id" => id, "user_id" => user_id}) do
    if authorisation(conn, user_id) do
      animal = AnimalContext.get_animal!(id)
      render(conn, "details.json", animal: animal)
    else
      conn
      |>send_resp(401, "Unauthorized")
    end
  end

    def update(conn, %{"id" => id, "animal" => animal_params, "user_id" => user_id}) do
      if authorisation(conn, user_id) do
        animal = AnimalContext.get_animal!(id)
        case AnimalContext.update_animal(animal, animal_params) do
          {:ok, %Animal{} = animal} ->
            render(conn, "details.json", animal: animal)

          {:error, _cs} ->
            conn
            |> send_resp(400, "Something went wrong, sorry. Adjust your parameters or give up.")
        end
      else
        conn
        |>send_resp(401, "Unauthorized")
      end
    end

    def delete(conn, %{"id" => id, "user_id" => user_id}) do
      if authorisation(conn, user_id) do
        animal = AnimalContext.get_animal!(id)

        with {:ok, %Animal{}} <- AnimalContext.delete_animal(animal) do
          send_resp(conn, :no_content, "")
        end
      else
        conn
        |>send_resp(401, "Unauthorized")
      end
    end

    def authorisation(conn, user_id) do
      api_key = get_req_header(conn,"x-api-key")
      user = UserContext.get_user(user_id)
      if user == nil do
        false
        conn
        |> send_resp(404, "User not found")
      else
      user_with_loaded_keys = ApiContext.load_api(user)
      keys = Enum.to_list(user_with_loaded_keys.api)
      auth = Enum.filter(keys, fn key -> String.equivalent?(key.key, api_key) end)
      !Enum.empty?(auth)
    end
  end
end
