module Api
  class CompaniesController < ApplicationController
    # GET /companies
    def index
      render json: CompanySerializer.render(Company.all, root: :companies)
    end

    # GET /companies/:id
    def show
      company = Company.find(params[:id])
      render json: CompanySerializer.render(company, root: :company)
    end

    # POST /bookings
    def create
      company = Company.new(company_params)

      if company.save
        render json: CompanySerializer.render(company, root: :company), status: :created
      else
        render json: { errors: company.errors }, status: :bad_request
      end
    end

    # UPDATE
    def update
      company = Company.find(params[:id])

      if company.update(company_params)
        render json: CompanySerializer.render(company, root: :company), status: :ok
      else
        render json: { errors: company.errors }, status: :bad_request
      end
    end

    # DESTROY
    def destroy
      Company.find(params[:id]).destroy
    end

    private

    def company_params
      params.require(:company).permit(:id, :name)
    end
  end
end
