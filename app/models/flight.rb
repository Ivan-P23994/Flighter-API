class Flight < ApplicationRecord
  belongs_to :company

  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :company_id }
  # validates :departs_at, presence: true, comparison: { less_than: :arrives_at }
  validates :arrives_at, presence: true
  validates :base_price, presence: true, numericality: { greater_than: 0 }
  validates :no_of_seats, presence: true, numericality: { greater_than: 0 }

  def depart_time_valid?
    return if departs_at < arrives_at

    errors.add(:flight, 'departure must be before arrival')
  end
end
