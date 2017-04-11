defmodule Imageapi.Foodimage do
  use Imageapi.Web, :model

  schema "foodimage" do
    field :foodname, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:foodname])
    |> validate_required([:foodname])
  end
end
