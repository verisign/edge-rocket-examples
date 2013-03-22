HTTP Basic Auth
===============

This is an implementation of HTTP Basic Auth. It prompts the client for username/password. The credentials are pulled from the table named _auth_. Currently the password is assumed to be stored in the data table in plain text, if that's not the case you can always hash the password returned by the base64.decode.

