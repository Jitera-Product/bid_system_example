class QuestionPolicy < ApplicationPolicy
  def update?
    user.admin? || record.user_id == user.id
  end
end


