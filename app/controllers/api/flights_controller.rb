module Api
  class FlightsController < ApplicationController
    before_action :authenticate

    # GET /Flights
    def index
      render json: FlightSerializer.render(Flight.all, root: :flights)
    end

    # GET /Flights/:id
    def show
      flight = Flight.find(params[:id])
      render json: FlightSerializer.render(flight, root: :flight)
    end

    # POST /bookings
    def create
      flight = authorize Flight.new(flight_params)

      if flight.save
        render json: FlightSerializer.render(flight, root: :flight), status: :created
      else
        render json: { errors: flight.errors }, status: :bad_request
      end
    end

    # UPDATE
    def update
      flight = authorize Flight.find(params[:id])

      if flight.update(flight_params)
        render json: FlightSerializer.render(flight, root: :flight), status: :ok
      else
        render json: { errors: flight.errors }, status: :bad_request
      end
    end

    # DESTROY
    def destroy
      flight = authorize Flight.find(params[:id])
      flight.destroy
    end

    private

    def flight_params
      params.require(:flight)
            .permit(:id, :departs_at, :arrives_at, :name,
                    :no_of_seats, :company_id, :base_price)
    end
  end
end
