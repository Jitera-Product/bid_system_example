# typed: true
# frozen_string_literal: true

class QuestionPolicy < ApplicationPolicy
  def create?
    user.role == 'contributor'
  end

  def update?
    user.admin? || record.user_id == user.id
  end
end
