# typed: true
# frozen_string_literal: true

class QuestionPolicy < ApplicationPolicy
  def create?
    user.role == 'contributor'
  end

  def update?
    return false unless user
    user.admin? || record.user_id == user.id
  end

  def moderate?
    user.admin?
  end

  # Other policy methods below
  # Ensure to include all other methods that were part of the existing code
  # to maintain functionality.
end
