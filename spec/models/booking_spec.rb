RSpec.describe Booking do
  subject { create(:booking) }

  it { is_expected.to validate_presence_of(:no_of_seats) }
  it { is_expected.to validate_presence_of(:seat_price) }

  it { is_expected.to validate_numericality_of(:seat_price).is_greater_than(0) }
  it { is_expected.to validate_numericality_of(:no_of_seats).is_greater_than(0) }

  it { is_expected.to belong_to(:flight) }
  it { is_expected.to belong_to(:user) }

  describe '#departure_can_not_be_after_arrival' do
    let(:booking) { create(:booking) }

    it 'validates when departs_at < arrives_at' do
      valid_booking = booking
      valid_booking.flight.departs_at = DateTime.now - 1.year
      valid_booking.departure_can_not_be_after_arrival

      expect(valid_booking.errors.count).to eq(0)
    end

    it 'does not validate when departs_at > DateTime.now' do
      invalid_booking = booking
      invalid_booking.flight.departs_at += 1.year
      invalid_booking.departure_can_not_be_after_arrival

      expect(invalid_booking.errors.count).to eq(1)
    end
  end
end
