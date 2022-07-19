require '/Users/ivanpavlovic/Desktop/VSC/rails-assignment-Ivan-P23994/app/domains/open_weather_map/resolver'
#require_relative 'rails-assignment-Ivan-P23994/app/domains/open_weather_map/resolver'

RSpec.describe OpenWeatherMap::Resolver do
  it 'returns correct Id' do
    expect(OpenWeatherMap::Resolver.city_id('Taglag')).to eq(3245)
  end

  it 'returns Nil' do
    expect(OpenWeatherMap::Resolver.city_id(331)).to eq(nil)
  end
end
