-- this script will serve a CSS file from within the db

-- create an endpoint similiar to this (change "user")
-- http://css.user.er.edgerocket.com/
-- and map this script to that endpoint

-- Also, create a db called "css" where you store your css data
-- and ensure that the service has access to that table

-- For this example,
-- a url like http://css.user.er.edgerocket.com/styles.css

-- request.getPath() will return "/styles.css"
-- strip of the leading slash
local css_name = string.sub(request.getPath(), 2)

-- css_file should now be "styles.css"
-- for this example, there should be an entry in the css table with
-- a key of "styles.css" and the value should be the actuall css

-- get the css file from the db
local css_file = db.get("css", css_name)

-- css_file will contain the contents of the css file or
-- nil if not found

-- to add other style sheets, simply add then to the table

if css_file == nil then
  -- if we don't find the file, return a 404
  response.addHeader("Content-Type", "text/html")
  response.addHeader("Cache-Control", "no-cache, no-store, max-age=0, must-revalidate")
  response.addHeader("Pragma", "no-cache")
  response.addHeader("Expires", "Fri, 01 Jan 1990 00:00:00 GMT")

  response.setResponseCode("404")
  response.setResponseText("Not Found")
else
  -- if we found the css file, return it
  response.addHeader("Content-Type", "text/css")
  response.setBody(css_file)
end

