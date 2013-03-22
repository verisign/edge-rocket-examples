local renderTemplate = function(string, params)
  if not params then
    params = string
    string = params[1]
  end
  return (string.gsub(string, "({([^}]+)})",
    function(full,i)
      return params[i] or full
    end))
end

local found_html = [[
    <html><head><title>EdgeRocket</title></head><body>
        <p>{table}.{key} = {value}</p>
    </body></html>
    ]]

local notfound_html = [[
    <html><head><title>EdgeRocket</title></head><body>
        <p>{table}.{key} Not Found</p>
    </body></html>
    ]]    

local params = request.getParams()
local table = params["table"]
local key = params["key"]

response.addHeader("Content-Type", "text/html")

if table == nil or key == nil then
  response.setResponseCode("404")
  response.setResponseText("Not Found")
  response.setBody(renderTemplate {notfound_html, table = table, key = key})
else
  local value = db.get(table, key)
  response.setBody(renderTemplate {found_html, table = table, key = key, value = value})
end

