require '/Users/ivanpavlovic/Desktop/VSC/rails-assignment-Ivan-P23994/app/domains/open_weather_map/resolver' # rubocop:disable Layout/LineLength
# require_relative 'rails-assignment-Ivan-P23994/app/domains/open_weather_map/resolver'

RSpec.describe OpenWeatherMap::Resolver do
  it 'returns correct Id' do
    expect(described_class.city_id('Taglag')).to eq(3245)
  end

  it 'returns Nil' do
    expect(described_class.city_id(331)).to eq(nil)
  end
end
