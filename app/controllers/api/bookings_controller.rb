module Api
  class BookingsController < ApplicationController
    before_action :authenticate

    # GET /Bookings
    def index
      booking = policy_scope(Booking)
      render json: BookingSerializer.render(booking, root: :bookings), status: :ok
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
  end
end
