class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include Pundit::Authorization

  before_action :require_json
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def authenticate
    return unless current_user.nil?

    render json: { errors: { token: ['is invalid'] } }, status: :unauthorized
  end

  def current_user
    @current_user ||= User.find_by(token: request.headers['Authorization'])
  end

  private

  def user_not_authorized
    render json: { errors: { resource: ['is forbidden'] } }, status: :forbidden
  end

  def not_found
    respond_to do |format|
      format.json { head :not_found }
    end
  end

  def require_json
    return if request.headers['Content-Type'] == 'application/json'

    render json: { errors: { content_type: ['not recognized'] } }, status: :unsupported_media_type
  end
end
