local json = require "json"

local lua_table = {a = 1, b = 2, c = {d = 3, e = 4}}
local encoded_json = json:encode(lua_table)

local json_in = '{"a":1,"b":2,"c":{"d":3,"e":4}}'
local decoded_json = json:decode(json_in)

local function dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k,v in pairs(o) do
      if type(k) ~= 'number' then k = '"'..k..'"' end
      s = s .. '['..k..'] = ' .. dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

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

local html = [[
    <html><head><title>JSON Samples</title></head><body>
    <h1>Encoded (Lua Table to JSON)</h1>
        <p>{encoded}</p>
    <h1>Decoded (JSON - Lua Table)</h1>
        <p>{decoded}</p>
    </body></html>
    ]]

response.addHeader("Content-Type", "text/html")
response.setBody(renderTemplate(html, {encoded = encoded_json, decoded = dump(decoded_json)}))

