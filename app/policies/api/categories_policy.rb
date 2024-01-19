
class Api::CategoriesPolicy < ApplicationPolicy
  # existing methods

  def contributor?
    user.is_a?(User) && user.role == 'contributor'
  end

end
