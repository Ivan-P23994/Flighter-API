class CompanySerializer < Blueprinter::Base
  identifier :id
  field :name
  field(:no_of_active_flights) do |company, _options|
    company.flights.where('departs_at > ?', DateTime.now).count
  end
  field :created_at
  field :updated_at
end
