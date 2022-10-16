## 👾 Tech Stack

[![My Skills](https://skillicons.dev/icons?i=ruby,rails,postgres)](https://skillicons.dev)

## Summary


![db](https://user-images.githubusercontent.com/101200406/196042017-61d9c2d6-b804-4c15-9c1e-6a115547088a.png)

This projects main goal was to display my abilities in terms of building a Ruby on Rails API. 

### First Part

The first part consist of a client wrapper for the 'open weather map' API using a HTTP client. I used the 'HTTP' gem.
The response from the weather API is in JSON format so my next step was to convert that raw data into manageable domain classes.
The following are the features enabled by this part of the API:

- Ability to fetch the current weather for a single city name
- Ability to fetch the current weather for multiple cities
- Ability to fetch the current weather for a single city and multiple cities in the vicitiny(as compared to longitude and latitude)
- Ability to fetch the current weather for multiple cities and return the city with the coldest temperature among them

### Second Part

The second part consisted of adding CRUD controllers, routes and models together with serializers for every resource using the 'blueprinter' gem.
Which was followed by adding unit tests for the models in questions using the 'shoulda-matchers' gem.

Furthermore I wanted to add the ability for the user to register, so I intergrated 'has_secure_password' class method and added password_digest column to the User model. To include the ability to login I created a session controller which uses the 'has_secure_token' class method‚ the request to login contains an email and password and responds with a session token and user information. After login subsequent resquests are authenticated via session token which is provided in the Authorization header, the authorisation concerns were done using the 'Pundit' gem.  Successful logout destroys the session boject and regenerates the token for the currently authenticated user. Every new functionaliy implementation was backed up by request tests.

To round it all up I added both rails and custom constraints to the models. Lastly I added support for active filters using scopes and queries.



