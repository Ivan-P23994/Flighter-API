module Api
  class BookingsController < ApplicationController
    before_action :authenticate

    # GET /Bookings
    def index
      render json: BookingSerializer.render(Booking.all, root: :bookings), status: :ok
    end

    # GET /Bookings/:id
    def show
      booking = Booking.find(params[:id])
      user_owns_booking?(booking)

      render json: BookingSerializer.render(booking, root: :booking), status: :ok
    end

    # POST /bookings
    def create
      booking = Booking.new(booking_params)
      user_owns_booking?(booking) if booking.valid?

      if booking.save
        render json: BookingSerializer.render(booking, root: :booking), status: :created
      else
        render json: { errors: booking.errors }, status: :bad_request
      end
    end

    # PATCH
    def update
      booking = Booking.find(params[:id])
      return if user_owns_booking?(booking) && valid_booking_params? == false # TODO: refactor

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
      params.require(:booking).permit(:id, :no_of_seats, :seat_price,
                                      :flight_id, :user_id, :updated_at, :created_at)
    end

    def user_owns_booking?(booking)
      return if booking.user_id == current_user.id

      render json: { errors: { booking: ['user is not owner'] } }, status: :unauthorized
      false
    end

    def valid_booking_params?
      return if booking_params[:user_id].nil?

      render json: { errors: { paramters: ['changing booking ownership is forbidden'] } },
             status: :unauthorized
      false
    end
  end
end
