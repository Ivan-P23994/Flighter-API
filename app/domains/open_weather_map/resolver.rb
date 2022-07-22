module OpenWeatherMap
  module Resolver
    def self.city_id(name)
      city_id = JSON.parse(
        File.read(
          File.expand_path('city_ids.json', __dir__)
        )
      ).to_h do |city|
        [city['name'], city['id']][name.to_s]
      end
      city_id.nil? ? nil : city_id
    end
  end
end
