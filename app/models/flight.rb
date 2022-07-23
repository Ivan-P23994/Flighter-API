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
  belongs_to :company

  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :company_id }

  validates :departs_at, presence: true
  validates :arrives_at, presence: true

  validates :base_price, presence: true, numericality: { greater_than: 0 }
  validates :no_of_seats, presence: true, numericality: { greater_than: 0 }

  validate :depart_time_valid?

  def depart_time_valid?
    return if (departs_at && arrives_at).nil?
    return if departs_at.before?(arrives_at)

    errors.add(:departs_at, message: 'departure must be before arrival')
  end
end
