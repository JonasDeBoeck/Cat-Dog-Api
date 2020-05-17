defmodule MajorProjectWeb.UserController do
  use MajorProjectWeb, :controller

  alias MajorProject.UserContext
  alias MajorProject.UserContext.User
  alias MajorProject.AnimalContext
  alias MajorProject.AnimalContext.Animal
  alias MajorProject.ApiContext
  alias MajorProject.ApiContext.Api

  def index(conn, _params) do
    user =  Guardian.Plug.current_resource(conn)
    user_with_animals = AnimalContext.load_animals(user)
    render(conn, "index.html", user: user_with_animals)
  end

  def users(conn, _params) do
    users = UserContext.list_users()
    render(conn, "users.html", users: users)
  end

  def profile(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    user_with_keys = ApiContext.load_api(user)
    changeset = ApiContext.change_api(%Api{})
    render(conn, "show.html", user: user_with_keys, changeset: changeset)
  end

  def edit_password(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    changeset = UserContext.change_user(user)
    render(conn, "edit_password.html", user: user, changeset: changeset)
  end

  def update_password(conn, %{"user" => %{"password" => password, "oldPassword" => oldPassword, "verifyPassword" => verifyPassword}}) do
    user = Guardian.Plug.current_resource(conn)
    changeset = UserContext.change_user(user)
    if password == verifyPassword do
      if UserContext.password_check(user, oldPassword) do
        case UserContext.update_password(user, %{"password" => password}) do
          {:ok, user} ->
            conn
            |> put_flash(:info, gettext("User updated successfully."))
            |> redirect(to: Routes.user_path(conn, :profile))

          {:error, %Ecto.Changeset{} = error} ->
            render(conn, "edit_password.html", user: user, changeset: error)
        end
      else
        updated_changeset = Ecto.Changeset.add_error(changeset, :oldPassword, gettext("Old password doesn't match"))
        updated_changeset = Ecto.Changeset.apply_action(updated_changeset, :update)
        render(conn, "edit_password.html", user: user, changeset: elem(updated_changeset, 1))
      end
   else
      updated_changeset = Ecto.Changeset.add_error(changeset, :newPassword, gettext("Passwords don't match"))
      updated_changeset = Ecto.Changeset.add_error(updated_changeset, :verifyPassword, gettext("Passwords don't match"))
      updated_changeset = Ecto.Changeset.apply_action(updated_changeset, :update)
      render(conn, "edit_password.html", user: user, changeset: elem(updated_changeset, 1))
    end
  end

  def edit_username(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    changeset = UserContext.change_user(user)
    render(conn, "edit_username.html", user: user, changeset: changeset)
  end

  def update_username(conn, %{"user" => %{"username" => username}}) do
    user = Guardian.Plug.current_resource(conn)

    case UserContext.update_username(user, %{"username" => username}) do
      {:ok, user} ->
        conn
        |> put_flash(:info, gettext("User updated successfully."))
        |> redirect(to: Routes.user_path(conn, :profile))

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)
        render(conn, "edit_username.html", user: user, changeset: changeset)
    end
  end

  def register(conn, _params) do
    changeset = UserContext.change_user(%User{})
    roles = UserContext.get_acceptable_roles()
    render(conn, "register.html", changeset: changeset, acceptable_roles: roles)
  end

  def register_user(conn, %{"user" => %{"password" => password, "confirmPassword" => confirmPassword, "username" => username, "role" => role}}) do
    changeset = UserContext.change_user(%User{})
    if (password == confirmPassword) do
      user_params = %{"password" => password, "username" => username, "role" => role}
      case UserContext.create_user(user_params) do
        {:ok, user} ->
          conn
          |> put_flash(:info, gettext("User created successfully."))
          |> redirect(to: Routes.user_path(conn, :users))

        {:error, %Ecto.Changeset{} = changeset} ->
          roles = UserContext.get_acceptable_roles()
          render(conn, "register.html", changeset: changeset, acceptable_roles: roles)
      end
    else
      roles = UserContext.get_acceptable_roles()
      conn
      |> put_flash(:error, gettext("Passwords didn't match"))
      render(conn, "register.html", changeset: changeset, acceptable_roles: roles)
    end
  end

  def new(conn, _params) do
    changeset = UserContext.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => %{"password" => password, "confirmPassword" => confirmPassword, "username" => username}}) do
    changeset = UserContext.change_user(%User{})
    if (password == confirmPassword) do
      user_params = %{"password" => password, "username" => username, "role" => "User"}
      case UserContext.create_user(user_params) do
        {:ok, user} ->
          conn
          |> put_flash(:info, gettext("User created successfully."))
          |> redirect(to: Routes.session_path(conn, :new))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    else
      conn
      |> put_flash(:error, gettext("Passwords didn't match"))
      render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"user_id" => id}) do
    user = UserContext.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"user_id" => id}) do
    user = UserContext.get_user!(id)
    changeset = UserContext.change_user(user)
    roles = UserContext.get_acceptable_roles()
    render(conn, "edit.html", user: user, changeset: changeset, acceptable_roles: roles)
  end

  def update(conn, %{"user_id" => id, "user" => user_params}) do
    user = UserContext.get_user!(id)

    case UserContext.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, gettext("User updated successfully."))
        |> redirect(to: Routes.user_path(conn, :users))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"user_id" => id}) do
    user = UserContext.get_user!(id)
    {:ok, _user} = UserContext.delete_user(user)

    conn
    |> put_flash(:info, gettext("User deleted successfully."))
    |> redirect(to: Routes.user_path(conn, :index))
  end

  def delete_key(conn, %{"api_id" => id}) do
    key = ApiContext.get_api!(id)
    user = Guardian.Plug.current_resource(conn)
    if key.user_id == user.id do
      {:ok, _key} = ApiContext.delete_api(key)
      conn
      |> put_flash(:info, gettext("Key deleted successfully."))
      |> redirect(to: Routes.user_path(conn, :profile))
    else
      conn
      |> put_flash(:error, gettext("You can't delete other people's api keys."))
      |> redirect(to: Routes.user_path(conn, :profile))
    end
  end

  def create_api(conn, %{"api" => %{"name" => name}}) do
    user = Guardian.Plug.current_resource(conn)
    user_with_keys = ApiContext.load_api(user)
    key = ApiContext.random_string(64)
    case ApiContext.create_api(%{"key" => key, "name" => name}, user) do
      {:ok, key} ->
        conn
        |> put_flash(:info, gettext("Key created successfully."))
        |> redirect(to: Routes.user_path(conn, :profile))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "show.html", changeset: changeset, user: user_with_keys)
    end
  end

  def show_key(conn, %{"api_id" => id}) do
    key = ApiContext.get_api!(id)
    user = Guardian.Plug.current_resource(conn)
    if key.user_id == user.id do
      render(conn, "key.html", key: key)
    else
      conn
      |> put_flash(:error, gettext("You can't see other people's api keys."))
      |> redirect(to: Routes.user_path(conn, :profile))
    end
  end
end
