module Api
  class BookingsController < ApplicationController
    before_action :authenticate

    # GET /Bookings
    def index
      booking = policy_scope(Booking)
      booking = params[:filter].nil? ? booking : booking.active_flights

      render json: BookingSerializer.render(booking.includes([flight: [:company]]), root: :bookings), status: :ok
    end

    # GET /Bookings/:id
    def show
      booking = authorize Booking.find(params[:id])

      render json: BookingSerializer.render(booking, root: :booking), status: :ok
    end

    # POST /bookings
    def create
      booking = Booking.new(booking_params)
      booking.update(permitted_attributes(booking))
      regulate_ownership(booking)

      if booking.save
        render json: BookingSerializer.render(booking, root: :booking), status: :created
      else
        render json: { errors: booking.errors }, status: :bad_request
      end
    end

    # PATCH
    def update
      booking = authorize Booking.find(params[:id])

      if booking.update(permitted_attributes(booking))
        render json: BookingSerializer.render(booking, root: :booking), status: :ok
      else
        render json: { errors: booking.errors }, status: :bad_request
      end
    end

    # DESTROY
    def destroy
      booking = authorize Booking.find(params[:id])
      booking.destroy

      head :no_content
    end

    private

    def booking_params
      params.require(:booking).permit(:no_of_seats, :seat_price,
                                      :flight_id, :user_id)
    end

    def regulate_ownership(booking)
      if current_user.role.nil?
        booking.user_id = current_user.id
      elsif booking.user_id.nil?
        booking.user_id == current_user.id
      else
        true
      end
    end
  end
end
