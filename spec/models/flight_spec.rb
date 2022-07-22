RSpec.describe Flight do
  subject { create(:flight) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:departs_at) }
  it { is_expected.to validate_presence_of(:arrives_at) }
  it { is_expected.to validate_presence_of(:base_price) }

  it { is_expected.to validate_uniqueness_of(:name).case_insensitive.scoped_to(:company_id) }

  it { is_expected.to validate_numericality_of(:base_price).is_greater_than(0) }
  it { is_expected.to validate_numericality_of(:no_of_seats).is_greater_than(0) }

  it { is_expected.to belong_to(:company) }

  describe '#depart_time_valid' do
    let(:flight) { create(:flight) }

    it 'validates to true when departs_at < arrives_at' do
      expect(flight.depart_time_valid?).to eq(true)
    end

    it 'validates to false and throws an error when departs_at == arrives_at' do
      invalid_flight = flight
      invalid_flight.arrives_at = invalid_flight.departs_at

      expect(flight.depart_time_valid?).to eq(false)
    end

    it 'validates to false and throws an error when departs_at > arrives_at' do
      invalid_flight = flight
      invalid_flight.arrives_at -= 1.year

      expect(flight.depart_time_valid?).to eq(false)
    end
  end
end
