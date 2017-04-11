defmodule Imageapi.TestController do
  use Imageapi.Web, :controller
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

  json(conn,test_params)
end

end


