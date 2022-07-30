class UserPolicy < ApplicationPolicy
  attr_reader :user, :current_user

  def initialize(user, current_user) # rubocop:disable Lint/MissingSuper
    @user = user
    @current_user = current_user
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    admin?
  end

  def show?
    admin? || owner?
  end

  def update?
    admin? || owner?
  end

  def destroy?
    admin? || owner?
  end
end
