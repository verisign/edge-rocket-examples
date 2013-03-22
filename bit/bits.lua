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

local unary_view = [[
    <html><head><title>EdgeRocket</title></head><body>
        <p>{op} {lhs} = {result} </p>
    </body></html>
    ]]

local binary_view = [[
    <html><head><title>EdgeRocket</title></head><body>
        <p>{lhs} {op} {rhs} = {result} </p>
    </body></html>
    ]]

local params = request.getParams()
local op = params["op"]
local lhs = params["lhs"]
local rhs = params["rhs"]

local operations = {
  ["and"]    = function() return bit.band(lhs, rhs), binary_view end,
  ["or"]     = function() return bit.bor(lhs, rhs), binary_view end,
  ["xor"]    = function() return bit.bxor(lhs, rhs), binary_view end,
  ["not"]    = function() return bit.bnot(lhs), unary_view end,
  ["lshift"] = function() return bit.lshift(lhs, rhs), binary_view end,
  ["rshift"] = function() return bit.rshift(lhs, rhs), binary_view end
}

local result, view = operations[op]()

response.addHeader("Content-Type", "text/html")

response.setBody(renderTemplate {view, op = op, lhs = lhs, rhs = rhs, result = result})


