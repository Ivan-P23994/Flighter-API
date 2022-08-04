module Api
  class UsersController < ApplicationController
    before_action :authenticate, except: [:create]
    # GET /users
    def index
      authorize current_user

      users = User.filter(filter_params)
      render json: UserSerializer.render(users.ascending, root: :users)
    end

    # GET /users/:id
    def show
      user = authorize User.find(params[:id])

      render json: UserSerializer.render(user, root: :user)
    end

    # POST /users
    def create
      user = User.new(user_params)
      user.update(permitted_attributes(user)) # TODO: find proper way

      if user.save
        render json: UserSerializer.render(user, root: :user), status: :created
      else
        render json: { errors: user.errors }, status: :bad_request
      end
    end

    # UPDATE
    def update
      user = authorize User.find(params[:id])

      if user.update(permitted_attributes(user))
        render json: UserSerializer.render(user, root: :user), status: :ok
      else
        render json: { errors: user.errors }, status: :bad_request
      end
    end

    # DESTROY
    def destroy
      user = authorize User.find(params[:id])
      user.destroy
      head :no_content
    end

    private

    def user_params
      params.require(:user).permit(:id, :first_name, :last_name, :email, :password)
    end

    def filter_params
      params[:filter].slice(:first_name, :last_name, :email)
    end
  end
end
