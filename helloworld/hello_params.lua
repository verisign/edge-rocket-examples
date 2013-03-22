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

local hello_html = [[
    <html><head><title>Hello World</title></head><body>
    <img src="http://www.verisigninc.com/resources/img/logo.png" />
    <h1>EdgeRocket</h1>
        <p>Hello {name}</p>
    </body></html>
    ]]

local params = request.getParams()
local name = params["name"] or ""

response.addHeader("Content-Type", "text/html")

response.setBody(renderTemplate {hello_html, name = name} )
