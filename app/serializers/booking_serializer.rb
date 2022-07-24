class BookingSerializer < Blueprinter::Base
  identifier :id
  field :user_id
  field :flight_id
  field :seat_price
  field :no_of_seats
  field :created_at
  field :updated_at
end
