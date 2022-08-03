class FlightSerializer < Blueprinter::Base
  identifier :id
  field :name
  field :arrives_at
  field :departs_at
  field :base_price
  field :no_of_seats
  field :company_id
  field :created_at
  field :updated_at

  field :no_of_booked_seats do |flight, _options|
    flight.bookings.sum(&:no_of_seats)
  end

  field :company_name do |flight, _options|
    flight.company.name
  end

  field :current_price do |flight, _options|
    if DateTime.now >= flight.departs_at
      base_price
    else
      base_price + (base_price * (flight.departs_at - DateTime.now).to_i / 15)
    end
  end

  association :company, blueprint: CompanySerializer
end
