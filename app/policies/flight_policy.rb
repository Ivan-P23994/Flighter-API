class FlightPolicy < ApplicationPolicy
  def initialize(user, flight) # rubocop:disable Lint/MissingSuper
    @user = user
    @flight = flight
  end

  def create?
    admin?
  end

  def update?
    admin?
  end

  def destroy?
    admin?
  end

  class Scope < Scope
    # def resolve
    #   scope.all
    # end
  end
end
