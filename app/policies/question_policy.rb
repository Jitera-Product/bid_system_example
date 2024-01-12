
class QuestionPolicy < ApplicationPolicy
  def edit?(user, question)
    return true if user.admin? || question.user_id == user.id

    false
  end

  # Other policy methods...
end
