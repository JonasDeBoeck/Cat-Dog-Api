defmodule MajorProject.ApiContextTest do
  use MajorProject.DataCase

  alias MajorProject.ApiContext

  describe "api" do
    alias MajorProject.ApiContext.Api

    @valid_attrs %{key: "some key"}
    @update_attrs %{key: "some updated key"}
    @invalid_attrs %{key: nil}

    def api_fixture(attrs \\ %{}) do
      {:ok, api} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ApiContext.create_api()

      api
    end

    test "list_api/0 returns all api" do
      api = api_fixture()
      assert ApiContext.list_api() == [api]
    end

    test "get_api!/1 returns the api with given id" do
      api = api_fixture()
      assert ApiContext.get_api!(api.id) == api
    end

    test "create_api/1 with valid data creates a api" do
      assert {:ok, %Api{} = api} = ApiContext.create_api(@valid_attrs)
      assert api.key == "some key"
    end

    test "create_api/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ApiContext.create_api(@invalid_attrs)
    end

    test "update_api/2 with valid data updates the api" do
      api = api_fixture()
      assert {:ok, %Api{} = api} = ApiContext.update_api(api, @update_attrs)
      assert api.key == "some updated key"
    end

    test "update_api/2 with invalid data returns error changeset" do
      api = api_fixture()
      assert {:error, %Ecto.Changeset{}} = ApiContext.update_api(api, @invalid_attrs)
      assert api == ApiContext.get_api!(api.id)
    end

    test "delete_api/1 deletes the api" do
      api = api_fixture()
      assert {:ok, %Api{}} = ApiContext.delete_api(api)
      assert_raise Ecto.NoResultsError, fn -> ApiContext.get_api!(api.id) end
    end

    test "change_api/1 returns a api changeset" do
      api = api_fixture()
      assert %Ecto.Changeset{} = ApiContext.change_api(api)
    end
  end
end
