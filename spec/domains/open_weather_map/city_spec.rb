require '/Users/ivanpavlovic/Desktop/VSC/rails-assignment-Ivan-P23994/app/domains/open_weather_map/city' # rubocop:disable Layout/LineLength

RSpec.describe OpenWeatherMap::City do
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
end
