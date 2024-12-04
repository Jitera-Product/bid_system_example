class Api::ProductsPolicy < ApplicationPolicy
  def update?; end

  def create?
    # Assuming there is a method 'user' that returns the current user
    # and 'user.has_role?' to check user's role or permissions.
    user.present? && user.has_role?(:seller)
  end

end
