module Api
  class BookingsController < ApplicationController
    before_action :authenticate

    # GET /Bookings
    def index
      authorize current_user

      render json: BookingSerializer.render(Booking.all, root: :bookings), status: :ok
    end

    # GET /Bookings/:id
    def show
      booking = authorize Booking.find(params[:id])

      render json: BookingSerializer.render(booking, root: :booking), status: :ok
    end

    # POST /bookings
    def create
      booking = authorize Booking.new(booking_params)

      if booking.save
        render json: BookingSerializer.render(booking, root: :booking), status: :created
      else
        render json: { errors: booking.errors }, status: :bad_request
      end
    end

    # PATCH
    def update
      booking = Booking.find(params[:id])
      valid_booking_params?(booking)

      if booking.update(booking_params)
        render json: BookingSerializer.render(booking, root: :booking), status: :ok
      else
        render json: { errors: booking.errors }, status: :bad_request
      end
    end

    # DESTROY
    def destroy
      booking = authorize Booking.find(params[:id])
      booking.destroy
    end

    private

    def booking_params
      params.require(:booking).permit(:no_of_seats, :seat_price,
                                      :flight_id, :user_id)
    end

    def valid_booking_params?(booking)
      if booking_params[:user_id].nil?
        authorize booking, :update?
      else
        authorize booking, :index? # index --> admin?
      end
    end
  end
end
