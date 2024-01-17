
class QuestionPolicy < ApplicationPolicy
  def update?
    return false unless user
    user.admin? || record.user_id == user.id
  end

  # Other policy methods below
end
