class BookingPolicy < ApplicationPolicy
  attr_reader :user, :booking

  def initialize(user, booking) # rubocop:disable Lint/MissingSuper
    @user = user
    @booking = booking
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
    # def resolve
    #   scope.all
    # end
  end

  private

  def create_owner
    user.nil?
  end

  def owner?
    user.id == booking.user_id
  end
end
