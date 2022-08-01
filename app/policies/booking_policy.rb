class BookingPolicy < ApplicationPolicy
  attr_reader :user, :booking

  def initialize(user, booking) # rubocop:disable Lint/MissingSuper
    @user = user
    @booking = booking
  end

  def permitted_attributes
    if admin?
      [:no_of_seats, :seat_price, :flight_id, :user_id]
    else
      [:no_of_seats, :seat_price, :flight_id]
    end
  end

  def index?
    admin?
  end

  def show?
    admin? || owner?
  end

  def create?
    owner?
  end

  def update?
    admin? || owner?
  end

  def destroy?
    admin? || owner?
  end

  class Scope < Scope
    def resolve
      if user.role.nil?
        scope.where(user_id: user.id)
      else
        scope.all
      end
    end
  end

  private

  def owner?
    user.id == booking.user_id
  end
end
