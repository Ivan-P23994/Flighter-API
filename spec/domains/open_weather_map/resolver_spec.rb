RSpec.describe OpenWeatherMap::Resolver do
  it 'returns correct Id' do
    expect(described_class.city_id('Taglag')).to eq(3245)
  end

  it 'returns Nil' do
    expect(described_class.city_id(331)).to eq(nil)
  end
end
