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
        <p>Hello <a href="mailto:{email}">{name}</a></p>
    </body></html>
    ]]

local params = request.getParams()
local user = params["user"] or ""

local emailAddress = db.get("email", user)

response.addHeader("Content-Type", "text/html")

response.setBody(renderTemplate {hello_html, name = user, email=emailAddress} )
