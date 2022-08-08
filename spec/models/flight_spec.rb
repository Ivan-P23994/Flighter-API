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
    let(:flight1) { create(:flight) }

    it 'validates when departs_at < arrives_at' do
      expect(flight1).to be_valid
    end

    it 'does not validate when departs_at == arrives_at' do
      flight.arrives_at = flight.departs_at
      flight.valid?

      expect(flight).to be_invalid
    end

    it 'does not validate when departs_at > arrives_at' do
      flight.arrives_at -= 1.year
      flight.valid?

      expect(flight).to be_invalid
    end
  end

  describe '.flight_overlapping? when flight valid' do
    let(:company) { create(:company) }
    let(:flight1) { create(:flight) }
    let(:flight2) { create(:flight) }

    it 'validates when flights do not overlap' do
      expect(flight2).to be_valid
    end
  end

  describe '.flight_overlapping? when flight invalid' do
    let(:company) { create(:company) }
    let(:flight1) { create(:flight, company_id: company.id, departs_at: DateTime.now, arrives_at: DateTime.now + 1.day) }         # rubocop:disable Layout/LineLength
    let(:flight2) { build(:flight, company_id: company.id, departs_at: DateTime.now, arrives_at: flight1.arrives_at) }           # rubocop:disable Layout/LineLength

    it 'does not validates when flights overlap' do
      expect(flight2).to be_invalid
    end
  end
end
