module OpenWeatherMap
  module Resolver
    def self.city_id(name)
      cities = JSON.parse(File.read(File.expand_path('city_ids.json', __dir__)))
      city_id = cities.to_h { |city| [city['name'], city['id']] }[name.to_s]
      city_id.nil? ? nil : city_id
    end
  end
end
