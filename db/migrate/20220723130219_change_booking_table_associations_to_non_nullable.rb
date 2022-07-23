class ChangeBookingTableAssociationsToNonNullable < ActiveRecord::Migration[6.1]
  def change
    change_column_null :bookings, :user_id, false
    change_column_null :bookings, :flight_id, false
  end
end
