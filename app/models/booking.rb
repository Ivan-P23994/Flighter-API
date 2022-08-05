# == Schema Information
#
# Table name: bookings
#
#  id          :bigint           not null, primary key
#  no_of_seats :integer          not null
#  seat_price  :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  flight_id   :bigint           not null
#  user_id     :bigint           not null
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
  belongs_to :flight, -> { order(departs_at: :asc, name: :asc) }, inverse_of: :bookings

  default_scope { order(created_at: :asc) }

  scope :active_flights, -> { joins(:flight).where('flights.departs_at > ?', DateTime.now) }

  validates :seat_price, presence: true, numericality: { greater_than: 0 }
  validates :no_of_seats, presence: true, numericality: { greater_than: 0 }

  validate :departure_time_valid?
  validate :no_of_seats_valid?

  def departure_time_valid?
    return if flight.nil?
    return if flight.departs_at > DateTime.now

    errors.add(:flight, 'departure time can not be in the past')
  end

  def no_of_seats_valid?
    return if no_of_seats.nil? || flight.nil?
    return if (flight.bookings.sum(&:no_of_seats) + no_of_seats) <= flight.no_of_seats

    errors.add(:no_of_seats, 'seat number higher than available ')
  end
end
