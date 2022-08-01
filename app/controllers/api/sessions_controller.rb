module Api
  class SessionsController < ApplicationController
    before_action :authenticate, only: [:destroy]
    def create
      user = User.find_by(email: params[:session][:email])

      if user.present? && user.authenticate(params[:session][:password]) # TODO: shift to session
        session = Session.new(session_params)
        render json: SessionSerializer.render(session, root: :session), status: :created
      else
        render json: { errors: { credentials: ['are invalid'] } }, status: :bad_request
      end
    end

    def destroy
      user = User.find_by(token: request.headers['Authorization'])
      user.regenerate_token
      head :no_content
    end

    private

    def session_params
      params.require(:session).permit(:password, :email)
    end
  end
end
