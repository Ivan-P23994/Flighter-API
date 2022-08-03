module Api
  class CompaniesController < ApplicationController
    before_action :authenticate, except: [:index, :show]
    # GET /companies
    def index
      companies = params[:filter].nil? ? Company.all : Company.active_flights
      render json: CompanySerializer.render(companies.ascending, root: :companies)
    end

    # GET /companies/:id
    def show
      company = Company.find(params[:id])
      render json: CompanySerializer.render(company, root: :company)
    end

    # POST /bookings
    def create
      company = authorize Company.new(company_params)

      if company.save
        render json: CompanySerializer.render(company, root: :company), status: :created
      else
        render json: { errors: company.errors }, status: :bad_request
      end
    end

    # UPDATE
    def update
      company = authorize Company.find(params[:id])

      if company.update(company_params)
        render json: CompanySerializer.render(company, root: :company), status: :ok
      else
        render json: { errors: company.errors }, status: :bad_request
      end
    end

    # DESTROY
    def destroy
      company = authorize Company.find(params[:id])
      company.destroy
    end

    private

    def company_params
      params.require(:company).permit(:id, :name)
    end
  end
end
