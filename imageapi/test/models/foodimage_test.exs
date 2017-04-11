defmodule Imageapi.FoodimageTest do
  use Imageapi.ModelCase

  alias Imageapi.Foodimage

  @valid_attrs %{foodname: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Foodimage.changeset(%Foodimage{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Foodimage.changeset(%Foodimage{}, @invalid_attrs)
    refute changeset.valid?
  end
end
