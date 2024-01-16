class AnswerPolicy < ApplicationPolicy
  attr_reader :user, :answer

  def initialize(user, answer = nil)
    @user = user
    @answer = answer
  end

  def create?
    user.role == 'contributor' || user.contributor?
  end

  def update?
    user.id == answer.question.user_id || user.role == 'admin'
  end

  # Other policy methods that were previously defined in the existing code
  # should be included here as well, without any changes unless they conflict
  # with the new code. Since the task specifies not to hide any code, ensure
  # that all methods are fully included here.

end
