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
    File.cp(upload.path,"/precious/RCH-SPEC-ASSIGN/imagepi/images/#{imagename}")
    Logger.info "Image saved to /precious/RCH-SPEC-ASSIGN/imagepi/images/#{imagename}"
    Logger.info "#{imagename}"
    response = HTTPotion.post "http://localhost:8000/food_detection/detect/" , [body: "url=/precious/RCH-SPEC-ASSIGN/imagepi/images/#{imagename}", headers: ["User-Agent": "My App", "Content-Type": "application/x-www-form-urlencoded"]]
    Logger.info "#{HTTPotion.Response.success?(response)}"
    Logger.info "#{response.body}"
    json(conn,response.body)
  else
    json(conn,test_params)
  end
 
# response = HTTPotion.get "httpbin.org/get"

end

end


