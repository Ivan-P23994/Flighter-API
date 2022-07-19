require 'byebug'

module OpenWeatherMap
  def self.city(string)
    id = OpenWeatherMap::Resolver.city_id(string)
    if id.nil?
      nil
    else
      response = HTTP.get("https://api.openweathermap.org/data/2.5/weather?id=#{id}&appid=37232143b89be9c7b2e089648313c3b9")
    end
    city = JSON.parse(response.body.to_s)
    # byebug
    OpenWeatherMap::City.parse(city)
  end
end
