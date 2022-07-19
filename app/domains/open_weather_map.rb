require 'byebug'

module OpenWeatherMap
  def self.city(item)
    id = OpenWeatherMap::Resolver.city_id(item)

    return nil if id.nil?

    response = HTTP.get("https://api.openweathermap.org/data/2.5/weather?id=#{id}&appid=37232143b89be9c7b2e089648313c3b9")

    json_city = JSON.parse(response.body.to_s)
    OpenWeatherMap::City.parse(json_city)
  end

  def self.cities(items)
    ids_arr = items.map { |name| OpenWeatherMap::Resolver.city_id(name) }
    ids_arr.compact!
    ids_arr = ids_arr.join(',')
    
    response = HTTP.get("https://api.openweathermap.org/data/2.5/group?id=#{ids_arr}&appid=37232143b89be9c7b2e089648313c3b9")
    json_cities = JSON.parse(response.body.to_s)
    
    json_cities['list'].map { |city| OpenWeatherMap::City.parse(city) }
  end
end
