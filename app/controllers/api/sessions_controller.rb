module Api
  class SessionsController < ApplicationController
    def create
      user = User.find_by(email: params[:session][:email])

      if user.present? && user.authenticate(params[:session][:password])
        session = Session.new(email: user.email, password: user.password)
        render json: SessionSerializer.render(session, root: :session), status: :created
      else
        render json: { errors: { credentials: ['are invalid'] } }, status: :bad_request
      end
    end

    def destroy
      # deletes user session
      session[:user_id] = nil
      redirect_to root_path, notice: 'Logged Out'
    end
  end
end
