Edgepress
=========

Edge Press makes it easy to create a main website page with some basic information as well as subpages. Each of the pages contains a header which can be updated via Twitter. This application is meant to be multi-tenanted, thus the hostname is included in each of the queries to the Edge Rocket data tables.

Currently three scripts are used to implement the 'customer' view of the website:
* _edgepress.lua_: This is the primary entry point to the website and builds the main page by displaying the content selected for the front page of the site.
* _posts.lua_: This script is responsible for finding the requested post and displaying it.


Main Page
---------

The main page pulls a template from the Edge Rocket database (from the _ep-templates_ table) along with substitution variables (from the _ep-vars_ table) and then simply combines them and returns the resulting web page.

Subpages
--------

Each of the subpages performs the same role as the main page script, but uses a different set of variables and potentially a different template.

Feed
----

Originally, Edgepress was envisioned as a blogging platform and so the notion of RSS/Atom feeds was useful. Here they serve more as an example of how to create RSS/Atom feeds on top of Edge Rocket, though they do provided a complete list of sub-pages as they are added.