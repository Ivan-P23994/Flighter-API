module Api
  class FlightsController < ApplicationController
    before_action :authenticate, except: [:index, :show]

    # GET /Flights
    def index
      flights = params.nil? ? Flight.all : Flight.filter(filter_params)

      render json: FlightSerializer.render(flights.includes([:company, :bookings])
                                   .active_flights.ascending, root: :flights)
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

    def filter_params
      params.slice(:name_cont, :departs_at_eq, :no_of_available_seats_qteq)
    end
  end
end
