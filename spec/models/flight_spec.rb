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

    it 'validates when departs_at < arrives_at' do
      expect(flight.depart_time_valid?).to eq(nil)
    end

    it 'does not validate when departs_at == arrives_at' do
      invalid_flight = flight
      invalid_flight.arrives_at = invalid_flight.departs_at
      invalid_flight.depart_time_valid?

      expect(invalid_flight.errors.count).to eq(1)
    end

    it 'does not validate when departs_at > arrives_at' do
      invalid_flight = flight
      invalid_flight.arrives_at -= 1.year
      invalid_flight.depart_time_valid?

      expect(invalid_flight.errors.count).to eq(1)
    end
  end
end
