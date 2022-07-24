class CompanySerializer < Blueprinter::Base
  identifier :id
  field :name
  # association :flights, blueprint: FlightSerializer
  field :created_at
  field :updated_at
end
