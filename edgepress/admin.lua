local renderTemplate = function(template, params)
  for k,v in pairs(params) do
    template = string.gsub(template, k, v)
  end
  return template
end

local encodedCredentials = request.getHeaderValue(HTTP_HEADER.AUTHORIZATION)
logger.info("New request from " .. request.getSourceIP())
if encodedCredentials ~= "" then
   local encodedDetails = string.gsub(encodedCredentials, "Basic ", "")
   local credentials = base64.decode(encodedDetails)
   -- if credentials is empty then it means that the details were not a valid Base64 encoding
   if credentials ~= "" then
      local username, password = string.match(credentials, "(%w+):(%w+)")
      local compare = db.get("ep-auth", username)

      if compare == password then
        local host     = request.getHeaderValue(HTTP_HEADER.HOST)
        local template = db.get("ep-templates", host .. ":admin")
        local name     = db.get("ep-vars", host .. ":owner")
        local links    = db.get("ep-vars", host .. ":pages")
        local apikey   = db.get("ep-vars", host .. ":apikey")
        local paramTbl = {}
        paramTbl['{owner}']  = name
        paramTbl['{pages}']  = links
        paramTbl['{apikey}'] = apikey
        paramTbl['{cid}'] = '12' -- need a way to get the collection id from the db for ep_vars
        paramTbl['{hostname}'] = request.getHost()
        response.addHeader("Content-Type", "text/html")
        response.setBody(renderTemplate(template,paramTbl))
        return 0
      end
   end
end

response.setResponseCode(401)
response.setResponseText("Unauthorized")
response.addHeader("WWW-Authenticate", "Basic realm=\"edgepress\"")
response.setBody("Authentication Required")

return 0
