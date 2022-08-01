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
      list_allowed = [:id, :first_name, :last_name, :email, :password]
      list_allowed << :role if current_user.nil? || current_user.role == 'admin'
      params.require(:user).permit(list_allowed)
    end
  end
end
