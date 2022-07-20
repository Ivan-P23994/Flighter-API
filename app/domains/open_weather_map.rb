module OpenWeatherMap
  DOMAIN = 'https://api.openweathermap.org/data/2.5/'
  API_KEY = Rails.application.credentials.config[:open_weather_map_api_key]

  def self.city(item)
    id = OpenWeatherMap::Resolver.city_id(item)
    return nil if id.nil?

    response = HTTP.get("#{DOMAIN}weather?id=#{id}&appid=#{API_KEY}")
    OpenWeatherMap::City.parse(response.parse.deep_symbolize_keys)
  end

  def self.cities(items)
    ids = items.filter_map { |name| OpenWeatherMap::Resolver.city_id(name) }.join(',')

    response = HTTP.get("#{DOMAIN}group?id=#{ids}&appid=#{API_KEY}")
    response.parse.deep_symbolize_keys[:list].map { |city| OpenWeatherMap::City.parse(city) }
  end
end
