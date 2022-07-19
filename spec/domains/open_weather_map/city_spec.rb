require 'rails_helper'
require '/Users/ivanpavlovic/Desktop/VSC/rails-assignment-Ivan-P23994/app/domains/open_weather_map/city' # rubocop:disable Layout/LineLength

RSpec.describe OpenWeatherMap::City do
  let(:city_class) { described_class.new }

  it 'temp method converts temperature correctly' do
    city_test = described_class.new(1, 2, 3, 'Taglag', 306)

    expect(city_test.temp).to eq(32.85)
  end

  describe '#<=>' do
    it 'reciever has a lower temperature than other' do
      city1 = described_class.new(1, 2, 3, 'Taglag', 306)
      city2 = described_class.new(1, 2, 3, 'Babina Greda', 280)

      expect(city1 <=> city2).to eq(-1)
    end

    it 'reciever has the same temperature but comes first alphabetically' do
      city1 = described_class.new(1, 2, 3, 'Taglag', 306)
      city2 = described_class.new(1, 2, 3, 'Babina Greda', 306)

      expect(city1 <=> city2).to eq(-1)
    end

    it 'reciever has the same temperature and name' do
      city1 = described_class.new(1, 2, 3, 'Taglag', 306)
      city2 = described_class.new(1, 2, 3, 'Taglag', 306)

      expect(city1 <=> city2).to eq(0)
    end

    it 'reciever has the higher temperature' do
      city1 = described_class.new(1, 2, 3, 'Taglag', 332)
      city2 = described_class.new(1, 2, 3, 'Samsun', 306)

      expect(city1 <=> city2).to eq(-1)
    end

    it 'reciever has the same temperature but the receiver name comes second alphabetically' do
      city1 = described_class.new(1, 2, 3, 'Babina Greda', 332)
      city2 = described_class.new(1, 2, 3, 'Taglag', 332)

      expect(city1 <=> city2).to eq(1)
    end
  end

  describe '#parse' do
    it 'correctly initializes provided hash values' do
      hash = { coord: { lat: 145.77, lon: -16.92 }, main: { temp: 300.15 }, id: 217_279_7, name: 'Cairns' }    # rubocop:disable Layout/LineLength
      city_instance = described_class.parse(hash)

      expect(city_instance.id).to eq(217_279_7)
      expect(city_instance.lat).to eq(145.77)
      expect(city_instance.lon).to eq(-16.92)
      expect(city_instance.name).to eq('Cairns')
      expect(city_instance.temp).to eq(27)
    end
  end
end
