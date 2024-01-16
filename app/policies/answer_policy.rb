
class AnswerPolicy < ApplicationPolicy
  attr_reader :user, :answer

  def update?
    user.id == answer.question.user_id || user.role == 'admin'
  end

  # Other policy methods...
end
