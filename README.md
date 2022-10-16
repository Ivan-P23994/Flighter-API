# Summary


![db](https://user-images.githubusercontent.com/101200406/196042017-61d9c2d6-b804-4c15-9c1e-6a115547088a.png)

This projects main goal was to display my abilities in terms of building a Ruby on Rails API. 

## 👾 Tech Stack

[![My Skills](https://skillicons.dev/icons?i=ruby,rails,postgres)](https://skillicons.dev)

## First Part

The first part consist of a client wrapper for the 'open weather map' API using a HTTP client. I used the 'HTTP' gem.
The response from the weather API is in JSON format so my next step was to convert that raw data into manageable domain classes.
The following are the features enabled by this part of the API:

- Ability to fetch the current weather for a single city name
- Ability to fetch the current weather for multiple cities
- Ability to fetch the current weather for a single city and multiple cities in the vicitiny(as compared to longitude and latitude)
- Ability to fetch the current weather for multiple cities and return the city with the coldest temperature among them

## Second Part

The second part consisted of adding CRUD controllers, routes and models together with serializers for every resource using the 'blueprinter' gem.
Which was followed by adding unit tests for the models in question, while using the 'shoulda-matchers' gem.


Furthermore I wanted to add the ability for the user to register, so I intergrated 'has_secure_password' class method and added password_digest column to the User model. The goal was to add the following functionality: 

 - Users can successfully register with a password
 - Users can't register without password
 - Users can successfully change password
 - Users can’t unset password (password: nil)

To include the ability to login I created a session controller which uses the 'has_secure_token' class method. The request and response were suposed to follow the following logic:

- Request contains email and password
- Response contains session token
- Response contains user information

After login subsequent resquests are authenticated via session token which is provided in the Authorization header, the authorisation concerns were done using the 'Pundit' gem. Additionaly I added a role attribute to the User model("admin" & nil).
The implemented authentications should yield the following constraints:

- Everyone can list and show companies and flights resources, even unauthorised requests
- Only authenticated requests can consume:
  - users resource
  - bookings resource
 
### User Authentication Permissions

- Only administrators can create, update and delete companies and flights resources
- Only administrators can list user resources
- Administrators can show/update/delete all user resources, others can act only on their own data
- Only administrators can update role attribute
- User shouldn't see other bookings from other users after creating a booking it should be owned by currently authenticated user
- Users should not be able to change ownership of the booking

### Booking Authentication Permissions

- Administrators can list all booking resources authenticated users can list only their own booking resources
- Administrators can show/update/delete all booking resources, others can act only on their own resources only administrators can update user_id attribute


Successful logout destroys the session boject and regenerates the token for the currently authenticated user. Every new functionaliy implementation was backed up by request tests. To top it off I added various filter supports for most of the resources using both rails scopes and manual SQL queries.





