-- This is the html we want to return. In Lua, a string that spans several lines
-- can be delimited with double square brackets.

local hello_html = [[
    <html><head><title>Hello World</title></head><body>
    <img src="http://www.verisigninc.com/resources/img/logo.png" />
    <h1>EdgeRocket</h1>
        <p>Hello World</p>
    </body></html>
    ]]

response.addHeader("Content-Type", "text/html")
response.setBody(hello_html)

