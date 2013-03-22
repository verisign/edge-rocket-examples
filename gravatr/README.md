Avatar Lookup Service
=====================

This example is modeled after the [gravatar](http://www.gravatar.com) service which maps an email address to an avatar image. It is used on various websites such as forums, blogs, GitHub, issue tracking services, etc. It allows you to associate your image with one or more of your email addresses. The avatar images are stored as JSON objects in the _avatars_ table of the format:

```javascript
{ "mime_type":"image/png", "image":"<Base64 encoded image>" }
```
