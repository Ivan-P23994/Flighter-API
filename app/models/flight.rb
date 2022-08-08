# == Schema Information
#
# Table name: flights
#
#  id          :bigint           not null, primary key
#  arrives_at  :datetime         not null
#  base_price  :integer          not null
#  departs_at  :datetime         not null
#  name        :string           not null
#  no_of_seats :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  company_id  :bigint
#
# Indexes
#
#  index_flights_on_company_id           (company_id)
#  index_flights_on_name_and_company_id  (name,company_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
class Flight < ApplicationRecord
  include Filterable

  belongs_to :company
  has_many :bookings, dependent: :destroy

  scope :ascending, -> { order(departs_at: :asc, name: :asc, created_at: :asc) }
  scope :active_flights, -> { where('departs_at > ?', DateTime.now) }

  scope :filter_by_name_cont, ->(name) { where('name ilike ?', "%#{name}%") }
  scope :filter_by_departs_at_eq, ->(time) { where("date_trunc('minute', departs_at) = ?", time.slice(0..15)) } # rubocop:disable Layout/LineLength
  scope :filter_by_no_of_available_seats_qteq,
        lambda { |seats|
          where('flights.departs_at > ?', DateTime.now)
            .left_joins(:bookings)
            .group(:id)
            .having('flights.no_of_seats - COALESCE(SUM(bookings.no_of_seats), flights.no_of_seats) >=  ?', seats)   # rubocop:disable Layout/LineLength
        }

  scope :overlapping_flights,
        lambda { |departs_at, arrives_at|
          where('(departs_at, arrives_at) OVERLAPS (?, ?)', departs_at, arrives_at)
        }

  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :company_id }

  validates :departs_at, presence: true
  validates :arrives_at, presence: true

  validates :base_price, presence: true, numericality: { greater_than: 0 }
  validates :no_of_seats, presence: true, numericality: { greater_than: 0 }

  validate :depart_time_valid?
  validate :flight_overlapping?, on: [:create]

  def depart_time_valid?
    return if (departs_at && arrives_at).nil?
    return if departs_at.before?(arrives_at)

    errors.add(:departs_at, message: 'departure must be before arrival')
  end

  def flight_overlapping?
    return if company.nil? || company.flights.empty?
    return if company.flights.overlapping_flights(departs_at, arrives_at).empty?

    errors.add(:departs_at, message: 'flight must not overlap')
    errors.add(:arrives_at, message: 'flight must not overlap')
  end

  def days_to_flight
    15 - ((Time.zone.now - departs_at).abs.round / 86_400)
  end
end
