# typed: true
# frozen_string_literal: true

class QuestionPolicy < ApplicationPolicy
  def create?
    user.role == 'contributor'
  end

  def update?
    # The update? method now checks if the user is a contributor and the owner of the question.
    user.role == 'contributor' && record.user_id == user.id
  end
end
