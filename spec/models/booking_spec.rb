RSpec.describe Booking do
  subject { create(:booking) }

  it { is_expected.to validate_presence_of(:no_of_seats) }
  it { is_expected.to validate_presence_of(:seat_price) }

  it { is_expected.to validate_numericality_of(:seat_price).is_greater_than(0) }
  it { is_expected.to validate_numericality_of(:no_of_seats).is_greater_than(0) }

  it { is_expected.to belong_to(:flight) }
  it { is_expected.to belong_to(:user) }

  describe '#depart_time_valid?' do
    let(:booking) { create(:booking) }

    it 'validates to true when departs_at < arrives_at' do
      valid_booking = booking
      valid_booking.flight.departs_at = DateTime.now - 1.year

      expect(valid_booking.depart_time_valid?).to eq(true)
    end

    it 'validates to false and throws an error when departs_at > DateTime.now' do
      invalid_booking = booking
      invalid_booking.flight.departs_at += 1.year

      expect(invalid_booking.depart_time_valid?).to eq(false)
    end
  end
end
