class FeedbackPolicy < ApplicationPolicy
  def create?
    user.is_a?(User) && user.role == 'Inquirer'
  end
end
