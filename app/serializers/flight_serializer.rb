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
    if (flight.departs_at - DateTime.now) <= 0
      flight.base_price * 2
    elsif flight.days_to_flight >= 15
      flight.base_price
    else
      flight.base_price + (flight.base_price * (flight.days_to_flight / 15.00)).to_i
    end
  end
  association :company, blueprint: CompanySerializer
end
