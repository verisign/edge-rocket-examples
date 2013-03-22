-- This is a simple example of an EdgeRocket script
-- that will generate an HTML page based on the value of
-- some get parameters and will make simple database queries.

-- lustache is a lua version of the JavaScript mustache templating library
-- https://github.com/Olivine-Labs/lustache
local lustache = require "lustache"

-- EdgeRocket automatically imports the "request," "response," and "db" modules
-- so there is no need to require them (though it is safe to do so).

-- Get a lua table of the get parameters passed in the url.
-- For example, if the url is http://<yourdomain>/<path>/<path>?a=123&b=test
-- then params would be a lua table like:
-- params['a'] = "123"
-- params['b'] = "test"

local params = request.getParams()

-- Get an optional message parameter passed in as a get parameter;
-- if not present, it will be set to nil.
local custom_message = params["message"]

-- Get a value from the "Small sample lookup table" table identified by the key "hello"
local hello_message = db.get("Small sample lookup table", "hello") or ""

-- Get a value from the "Small sample lookup table" table identified by the key "welcome"
local welcome_message = db.get("Small sample lookup table", "welcome") or ""

-- Create a "model" that will be rendered in HTML.
-- It is always recommended to use local variables as below,
-- as this is faster than using global variables (specified without 'local').
local model = {
    custom = custom_message,
    hello = hello_message,
    welcome = welcome_message
}


-- Create an HTML template that will be used to render our page.
-- In lua, multiline strings can be delimited with double square brackets.
local html_template = [[
<html>
  <head>
    <title>Welcome to EdgeRocket</title>
  </head>
  <body>
    <h1>{{hello}}</h1>
    <p>{{welcome}}</p>
    {{#custom}}<p>{{custom}}</p>{{/custom}}
  </body>
<html>
]]

-- Render the HTML template using the values in the model.
output = lustache:render(html_template, model)

-- Set the content type to "text/html";
-- there is no default for this so it MUST be set.
response.addHeader("Content-Type", "text/html")

-- Set the response body to the rendered template.
response.setBody(output)

