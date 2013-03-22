-- This the main page for the website and we use template to render
-- the site. The basic workflow is:
-- 1) Determine the hostname as this is used as a portion of the key.
-- 2) Retrieve template for the page
-- 3) Retrieve all of the substitution variables for the template
-- 4) Render the template and return it

local renderTemplate = function(template, params)
  for k,v in pairs(params) do
    template = string.gsub(template, k, v)
  end
  return template
end


local host      = request.getHeaderValue(HTTP_HEADER.HOST)
local template  = db.get("ep-templates", host .. ":main")
local name      = db.get("ep-vars", host .. ":owner")
local location  = db.get("ep-vars", host .. ":address")
local openclose = db.get("ep-vars", host .. ":hours")
local desc      = db.get("ep-vars", host .. ":description")
local tuser     = db.get("ep-vars", host .. ":twitter")
local links     = db.get("ep-vars", host .. ":pages")
local paramTbl  = {}
paramTbl['{owner}']       = name;
paramTbl['{address}']     = location;
paramTbl['{hours}']       = openclose;
paramTbl['{description}'] = desc;
paramTbl['{pages}']       = links;
paramTbl['{twitter}']     = tuser;

response.addHeader("Content-Type", "text/html")
response.addHeader("Access-Control-Allow-Origin", "*")
response.setBody(renderTemplate(template,paramTbl))

return 0
