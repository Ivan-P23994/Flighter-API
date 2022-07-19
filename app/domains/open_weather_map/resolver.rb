require 'json'

module OpenWeatherMap::Resolver
  def self.city_id(city_name)
    cities = JSON.parse(File.read(File.expand_path('small.json', __dir__)))
    city = cities.find { |c| c['name'] == city_name }
    city.nil? ? city : city['id']
  end
end
