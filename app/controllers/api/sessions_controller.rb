module Api
  class SessionsController < ApplicationController
    def create
      user = User.find_by(email: params[:email])
      # finds existing user, checks to see if user can be authenticated
      if user.present? && user.authenticate(params[:password])
      # sets up user.id sessions
        session[:user_id] = user.id
        render json: { status: :created, logged_in: true, user: user }
      else
        render json: { status: :bad_request }
      end
    end

    def destroy
      # deletes user session
      session[:user_id] = nil
      redirect_to root_path, notice: 'Logged Out'
    end
  end
end
