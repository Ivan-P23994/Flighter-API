module Api
  class UsersController < ApplicationController
    before_action :authenticate, except: [:create]
    # GET /users
    def index
      authorize current_user

      render json: UserSerializer.render(User.all, root: :users)
    end

    # GET /users/:id
    def show
      user = authorize User.find(params[:id])

      render json: UserSerializer.render(user, root: :user)
    end

    # POST /users
    def create
      user = User.new(user_params)

      if user.save
        render json: UserSerializer.render(user, root: :user), status: :created
      else
        render json: { errors: user.errors }, status: :bad_request
      end
    end

    # UPDATE
    def update
      user = User.find(params[:id])
      valid_params?(user)

      if user.update(user_params)
        render json: UserSerializer.render(user, root: :user), status: :ok
      else
        render json: { errors: user.errors }, status: :bad_request
      end
    end

    # DESTROY
    def destroy
      user = authorize User.find(params[:id])
      user.destroy
    end

    private

    def user_params
      params.require(:user).permit(:id, :first_name, :last_name, :email, :password, :role)
    end

    def valid_params?(user)
      if user_params[:role].nil?
        authorize user, :update?
      else
        authorize user, :index? # index --> admin?
      end
    end
  end
end
