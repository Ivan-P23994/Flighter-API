class FlightSerializer < Blueprinter::Base
  identifier :id
  field :name
  field :arrives_at
  field :departs_at
  field :base_price
  field :no_of_seats
  field :company_id
  association :company, blueprint: CompanySerializer
  field :created_at
  field :updated_at
end
