defmodule Imageapi.TestController do
  use Imageapi.Web, :controller
  use HTTPotion.Base
  require Logger

  #alias Imageapi.Test

def create(conn,test_params) do
  Logger.info "TestController create"
  IO.inspect test_params
  #changeset = Test.changeset(%Test{}, test_params)

  if upload = test_params["image"] do
    Logger.info  "User has sent a photo!"
    #extension = Path.extname(upload.filename)
    imagename = Path.basename(upload.filename)
    File.cp(upload.path, "/precious/RCH-SPEC-ASSIGN/RCH-SPEC-ASSIGN/imageapi/images/#{imagename}")
    Logger.info "Image saved to /precious/RCH-SPEC-ASSIGN/RCH-SPEC-ASSIGN/imageapi/images/#{imagename}"
    Logger.info "#{imagename}"
  end
# response = HTTPotion.get "httpbin.org/get"
  response = HTTPotion.post "http://localhost:8000/food_detection/detect/" , [body: "url=/home/shishir/foodrec/fooddetect_api/food_detector/data/demo/Egg_Sandwich.jpg", headers: ["User-Agent": "My App", "Content-Type": "application/x-www-form-urlencoded"]]
  Logger.info "#{HTTPotion.Response.success?(response)}"
  Logger.info "#{response.body}"
  json(conn,test_params)
end

end


