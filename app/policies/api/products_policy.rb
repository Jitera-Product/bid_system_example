class Api::ProductsPolicy < ApplicationPolicy
  def update?
    user.present?
  end

  def create?
    user.present?
  end
end