defmodule Imageapi.FoodimageControllerTest do
  use Imageapi.ConnCase

  alias Imageapi.Foodimage
  @valid_attrs %{foodname: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, foodimage_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing foodimage"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, foodimage_path(conn, :new)
    assert html_response(conn, 200) =~ "New foodimage"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, foodimage_path(conn, :create), foodimage: @valid_attrs
    assert redirected_to(conn) == foodimage_path(conn, :index)
    assert Repo.get_by(Foodimage, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, foodimage_path(conn, :create), foodimage: @invalid_attrs
    assert html_response(conn, 200) =~ "New foodimage"
  end

  test "shows chosen resource", %{conn: conn} do
    foodimage = Repo.insert! %Foodimage{}
    conn = get conn, foodimage_path(conn, :show, foodimage)
    assert html_response(conn, 200) =~ "Show foodimage"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, foodimage_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    foodimage = Repo.insert! %Foodimage{}
    conn = get conn, foodimage_path(conn, :edit, foodimage)
    assert html_response(conn, 200) =~ "Edit foodimage"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    foodimage = Repo.insert! %Foodimage{}
    conn = put conn, foodimage_path(conn, :update, foodimage), foodimage: @valid_attrs
    assert redirected_to(conn) == foodimage_path(conn, :show, foodimage)
    assert Repo.get_by(Foodimage, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    foodimage = Repo.insert! %Foodimage{}
    conn = put conn, foodimage_path(conn, :update, foodimage), foodimage: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit foodimage"
  end

  test "deletes chosen resource", %{conn: conn} do
    foodimage = Repo.insert! %Foodimage{}
    conn = delete conn, foodimage_path(conn, :delete, foodimage)
    assert redirected_to(conn) == foodimage_path(conn, :index)
    refute Repo.get(Foodimage, foodimage.id)
  end
end
