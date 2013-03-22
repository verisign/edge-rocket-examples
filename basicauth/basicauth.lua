local encodedCredentials = request.getHeaderValue(HTTP_HEADER.AUTHORIZATION)

response.addHeader("Content-Type", "text/html")
response.addHeader("Cache-Control", "no-cache, no-store, max-age=0, must-revalidate")
response.addHeader("Pragma", "no-cache")
response.addHeader("Expires", "Fri, 01 Jan 1990 00:00:00 GMT")

if encodedCredentials ~= "" then
   logger.info(encodedCredentials)
   local encodedDetails = string.gsub(encodedCredentials, "Basic ", "")
   logger.info(encodedDetails)
   local credentials = base64.decode(encodedDetails)
   -- if credentials is empty then it means that the details were not a valid Base64 encoding
   if credentials ~= "" then
      logger.info(credentials)
      local username, password = string.match(credentials, "(%w+):(%w+)")
      logger.info(username .. ":" .. password)
      local compare = db.get("auth", username)

      if compare == password then
         response.setBody("Congratulations! Your username and password worked!")
         return
      end
   end
end

response.setResponseCode(401)
response.setResponseText("Unauthorized")
response.addHeader("WWW-Authenticate", "Basic realm=\"edgerocket\"")
response.setBody("Authentication Required")

