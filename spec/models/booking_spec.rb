RSpec.describe Booking do
  subject { create(:booking) }

  it { is_expected.to validate_presence_of(:no_of_seats) }
  it { is_expected.to validate_presence_of(:seat_price) }

  it { is_expected.to validate_numericality_of(:seat_price).is_greater_than(0) }
  it { is_expected.to validate_numericality_of(:no_of_seats).is_greater_than(0) }

  it { is_expected.to belong_to(:flight) }
  it { is_expected.to belong_to(:user) }

  describe '#departure_time_valid?' do
    let(:booking) { create(:booking) }

    it 'validates when departs_at < arrives_at' do
      booking.flight.departs_at = DateTime.now + 1.year
      booking.valid?

      expect(booking).to be_valid
    end

    it 'does not validate when departs_at > DateTime.now' do
      booking.flight.departs_at -= (booking.flight.departs_at - DateTime.now) + 1.month
      booking.valid?

      expect(booking).to be_invalid
    end
  end
end
