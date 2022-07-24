module Api
  class BookingsController < ApplicationController
    # GET /Bookings
    def index
      render json: BookingSerializer.render(Booking.all, root: :bookings), status: :ok
    end

    # GET /Bookings/:id
    def show
      booking = Booking.find(params[:id])
      render json: BookingSerializer.render(booking, root: :booking), status: :ok
    end

    # POST /bookings
    def create
      booking = Booking.new(booking_params)

      if booking.save
        render json: BookingSerializer.render(booking, root: :booking), status: :created
      else
        render json: { errors: booking.errors }, status: :bad_request
      end
    end

    # UPDATE
    def update
      booking = Booking.find(params[:id])

      if booking.update(booking_params)
        render json: BookingSerializer.render(booking, root: :booking), status: :ok
      else
        render json: { errors: booking.errors }, status: :bad_request
      end
    end

    # DESTROY
    def destroy
      Booking.find(params[:id]).destroy
    end

    private

    def booking_params
      params.require(:booking).permit(:id, :no_of_seats, :seat_price, :flight_id, :user_id)
    end
  end
end
