class BookingSerializer < Blueprinter::Base
  identifier :id
  field :user_id
  field :flight_id
  field :seat_price
  field :no_of_seats
  field :created_at
  field :updated_at
  field :total_price do |booking, _options|
    booking.no_of_seats * booking.seat_price
  end
  association :user, blueprint: UserSerializer
  association :flight, blueprint: FlightSerializer
end
