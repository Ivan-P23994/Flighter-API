### Summary

This projects main goal was to display my abilities in terms of building a Ruby on Rails API. 

The first part consist of a client wrapper for the 'open weather map' API using a HTTP client. I used the 'HTTP' gem.
The response from the weather API is in JSON format so my next step was to convert that raw data into manageable domain classes.
The following are the feature enabeled by this part of the API:

- Ability to fetch the current weather for a single city name
- Ability to fetch the current weather for multiple cities
- Ability to fetch the current weather for a single city and multiple cities in the vicitiny(as compared to longitude and latitude)
- Ability to fetch the current weather for multiple cities and return the city with the coldest temperature among them

The second part consisted of adding CRUD controllers, routes and models together with serializers for every resource using the 'blueprinter' gem.
Which resulted in the following DB map:
</br>
![db](https://user-images.githubusercontent.com/101200406/196042017-61d9c2d6-b804-4c15-9c1e-6a115547088a.png)

### 👾 Tech Stack

[![My Skills](https://skillicons.dev/icons?i=ruby,rails,postgres)](https://skillicons.dev)
