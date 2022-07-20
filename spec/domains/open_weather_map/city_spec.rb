RSpec.describe OpenWeatherMap::City do
  let(:taglag) { { "id": 3245, "name": 'Taglag', "coord": { "lon": 44.9, "lat": 38.4 }, "main": { "temp": 306 } } } # rubocop:disable Layout/LineLength
  let(:babina_greda) { { "id": 3245, "name": 'Babina Greda', "coord": { "lon": 44.9, "lat": 38.4 }, "main": { "temp": 280 } } } # rubocop:disable Layout/LineLength
  let(:cairns) { { coord: { lat: 145.77, lon: -16.92 }, main: { temp: 300.15 }, id: 217_279_7, name: 'Cairns' } }   # rubocop:disable Layout/LineLength

  it 'temp method converts temperature correctly' do
    city = described_class.new(taglag)

    expect(city.temp).to eq(32.85)
  end

  describe '#>' do
    it 'reciever has a lower temperature than other' do
      city1 = described_class.new(babina_greda)
      city2 = described_class.new(taglag)

      expect(city1 < city2).to eq(true)
    end

    it 'reciever has the same temperature but comes first alphabetically' do
      city1 = described_class.new(taglag)
      city2 = described_class.new(babina_greda)

      expect(city1 > city2).to eq(true)
    end

    it 'reciever has the same temperature and name' do
      city1 = described_class.new(taglag)
      city2 = described_class.new(taglag)

      expect(city1 == city2).to eq(true)
    end

    it 'reciever has the higher temperature' do
      city2 = described_class.new(taglag)
      city1 = described_class.new(babina_greda)

      expect(city2 > city1).to eq(true)
    end

    it 'reciever has the same temperature but the receiver name comes second alphabetically' do
      city1 = described_class.new(babina_greda)
      city2 = described_class.new(taglag)
      city1.temp_k = 306

      expect(city1 < city2).to eq(true)
    end
  end

  describe '#parse' do
    it 'correctly initializes provided hash values' do
      city_instance = described_class.parse(cairns)

      expect(city_instance.id).to eq(217_279_7)
      expect(city_instance.lat).to eq(145.77)
      expect(city_instance.lon).to eq(-16.92)
      expect(city_instance.name).to eq('Cairns')
      expect(city_instance.temp).to eq(27)
    end
  end
end
