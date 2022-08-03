class CompanyPolicy < ApplicationPolicy
  def initialize(user, company) # rubocop:disable Lint/MissingSuper
    @user = user
    @company = company
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
