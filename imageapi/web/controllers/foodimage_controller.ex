defmodule Imageapi.FoodimageController do
  use Imageapi.Web, :controller
  require Logger

  alias Imageapi.Foodimage

  def index(conn, _params) do
    foodimage = Repo.all(Foodimage)
    render(conn, "index.html", foodimage: foodimage)
  end

  def new(conn, _params) do
    changeset = Foodimage.changeset(%Foodimage{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"foodimage" => foodimage_params}) do
    IO.inspect foodimage_params
    changeset = Foodimage.changeset(%Foodimage{}, foodimage_params)


Logger.info  "Uploading new photo..."
#System.cmd("curl --help", [])
#LsOut = os:cmd("curl -X POST 'http://localhost:8000/food_detection/detect/' -d 'url=/home/shishir/foodrec/fooddetect_api/food_detector/data/demo/image.jpg' ; echo")


if upload = foodimage_params["photo"] do
  Logger.info  "User has sent a photo!"
  extension = Path.extname(upload.filename)
  imagename = Path.basename(upload.filename)
  File.cp(upload.path, "/precious/RCH-SPEC-ASSIGN/RCH-SPEC-ASSIGN/imageapi/images/#{imagename}")
  Logger.info "Image saved to /precious/RCH-SPEC-ASSIGN/RCH-SPEC-ASSIGN/imageapi/images/#{imagename}"
  Logger.info "#{imagename}"
  
end




    case Repo.insert(changeset) do
      {:ok, _foodimage} ->
        conn
        |> put_flash(:info, "Image saved")
       #|> put_flash(:info, "Foodimage created successfully.")
        |> redirect(to: foodimage_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    foodimage = Repo.get!(Foodimage, id)
    render(conn, "show.html", foodimage: foodimage)
  end

  def edit(conn, %{"id" => id}) do
    foodimage = Repo.get!(Foodimage, id)
    changeset = Foodimage.changeset(foodimage)
    render(conn, "edit.html", foodimage: foodimage, changeset: changeset)
  end

  def update(conn, %{"id" => id, "foodimage" => foodimage_params}) do
    foodimage = Repo.get!(Foodimage, id)
    changeset = Foodimage.changeset(foodimage, foodimage_params)

    case Repo.update(changeset) do
      {:ok, foodimage} ->
        conn
        |> put_flash(:info, "Foodimage updated successfully.")
        |> redirect(to: foodimage_path(conn, :show, foodimage))
      {:error, changeset} ->
        render(conn, "edit.html", foodimage: foodimage, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    foodimage = Repo.get!(Foodimage, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(foodimage)

    conn
    |> put_flash(:info, "Foodimage deleted successfully.")
    |> redirect(to: foodimage_path(conn, :index))
  end
end
