-- This script handles the subpages for the website:
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
local page      = string.sub(request.getPath(), string.len("/pages/")+1)
local template  = db.get("ep-templates", host .. ":page")
local name      = db.get("ep-vars", host .. ":owner")
local body      = db.get("ep-vars", host .. ":" .. page .. ":content")
local links     = db.get("ep-vars", host .. ":pages")
if body == nil then
  template      = db.get("ep-templates", host .. ":404")
end

-- TODO: Once we have a JSON -> Lua table converter we need to get the page 'name' which corresponds to this page out of the links table.
local paramTbl  = {}
paramTbl['{owner}']    = name;
paramTbl['{pagename}'] = page;
paramTbl['{content}']  = body;
paramTbl['{pages}']    = links;

response.addHeader("Content-Type", "text/html")
response.setBody(renderTemplate(template,paramTbl))

return 0
