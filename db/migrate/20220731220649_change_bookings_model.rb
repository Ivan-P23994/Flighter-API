class ChangeBookingsModel < ActiveRecord::Migration[6.1]
  def change
    change_column_null :bookings, :user_id, true
    change_column_null :bookings, :flight_id, true
  end
end
