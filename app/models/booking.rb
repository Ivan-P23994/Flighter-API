# == Schema Information
#
# Table name: bookings
#
#  id          :bigint           not null, primary key
#  no_of_seats :integer          not null
#  seat_price  :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  flight_id   :bigint
#  user_id     :bigint
#
# Indexes
#
#  index_bookings_on_flight_id  (flight_id)
#  index_bookings_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (flight_id => flights.id)
#  fk_rails_...  (user_id => users.id)
#
class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :flight

  validates :seat_price, presence: true, numericality: { greater_than: 0 }
  validates :no_of_seats, presence: true, numericality: { greater_than: 0 }
  validate :departure_can_not_be_after_arrival #TODO: figure out custom validations

  def depart_time_valid?
    return unless flight.departs_at
    return true if flight.departs_at < DateTime.current

    errors.add(:booking, 'departure time can not be in the past')
    false
  end

  def departure_can_not_be_after_arrival
    errors.add(:booking, 'departure time can not be in the past') if
      flight.departs_at.present? && flight.departs_at < Date.current
  end
end
