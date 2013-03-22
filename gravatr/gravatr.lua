local function applyStringParams(string, params)
  if not params then
    params = string
    string = params[1]
  end
  return (string.gsub(string, "({([^}]+)})",
    function(full,i)
      return params[i] or full
    end))
end

-- strip initial '/'
local requestURI = string.sub(request.getPath(), 2)
local responseData
local mimeType
if string.len(requestURI) == 0 then
  responseData = ""
else
  responseData = db.get("avatars", requestURI) or ""
  if responseData ~= "" then
    -- { "mime_type":"image/png",   TODO: switch to gmatch
    mimeType = string.sub(responseData, 16, 24)
    logger.info(mimeType)
    logger.info(string.sub(responseData, 36, -4))
    -- this will return the empty string if the input is not valid Base64 encoded
    responseData = base64.decode(string.sub(responseData, 36, -4))
  end
end

local unknownKeyTemplate = [[
    <html><head><title>grava.tr</title></head><body>
    <img src="http://www.verisigninc.com/resources/img/logo.png" />
    <h1>Verisign Avatar Service</h1>
    http://grava.tr/{key} was not found. Learn more about this service <a href="#">here</a>
    </body></html>
    ]]

if responseData == "" then
  response.addHeader("Content-Type", "text/html")
  response.addHeader("Cache-Control", "no-cache, no-store, max-age=0, must-revalidate")
  response.addHeader("Pragma", "no-cache")
  response.addHeader("Expires", "Fri, 01 Jan 1990 00:00:00 GMT")

  response.setResponseCode("404")
  response.setResponseText("Not Found")
  response.setBody(applyStringParams{ unknownKeyTemplate, key=requestURI})
else
  response.addHeader("Content-Type", mimeType)
  response.setBody(responseData)
end

