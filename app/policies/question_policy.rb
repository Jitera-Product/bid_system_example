class QuestionPolicy < ApplicationPolicy
  def edit?(user, question)
    return false unless user
    user_role = user.role.to_s.downcase

    return true if user_role == 'contributor' && question.user_id == user.id

    super
  end

  # Other policy methods...
end
