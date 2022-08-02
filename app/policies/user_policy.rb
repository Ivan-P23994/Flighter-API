class UserPolicy < ApplicationPolicy
  attr_reader :user, :current_user

  def initialize(user, current_user) # rubocop:disable Lint/MissingSuper
    @user = user
    @current_user = current_user
  end

  def permitted_attributes_for_update
    if admin?
      [:id, :first_name, :last_name, :email, :password, :role]
    else
      [:id, :first_name, :last_name, :email, :password]
    end
  end

  def permitted_attributes_for_create
    if admin?
      [:id, :first_name, :last_name, :email, :password, :role]
    else
      [:id, :first_name, :last_name, :email, :password]
    end
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    admin?
  end

  def create?
    admin?
  end

  def show?
    admin? || owner?
  end

  def update?
    owner? || admin?
  end

  def destroy?
    admin? || owner?
  end

  def admin?
    return if new_user?

    user.role == 'admin'
  end

  def new_user?
    current_user.nil? || user.nil? == true
  end
end
