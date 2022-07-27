module Api
  class UsersController < ApplicationController
    # GET /users
    def index
      render json: UserSerializer.render(User.all, root: :users)
    end

    # GET /users/:id
    def show
      user = User.find(params[:id])
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

      if user.update(user_params)
        render json: UserSerializer.render(user, root: :user), status: :ok
      else
        render json: { errors: user.errors }, status: :bad_request
      end
    end

    # DESTROY
    def destroy
      User.find(params[:id]).destroy
    end

    private

    def user_params
      params.require(:user).permit(:id, :first_name, :last_name, :email, :password)
    end
  end
end
