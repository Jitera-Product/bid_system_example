
class AdminPolicy < ApplicationPolicy
  # existing methods

  def moderate_content?
    user.is_a?(Admin) && user.role == 'moderator'
  end

end
