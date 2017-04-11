defmodule Imageapi.Repo.Migrations.CreateFoodimage do
  use Ecto.Migration

  def change do
    create table(:foodimage) do
      add :foodname, :string

      timestamps()
    end

  end
end
