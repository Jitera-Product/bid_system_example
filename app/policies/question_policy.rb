# typed: true
# frozen_string_literal: true

class QuestionPolicy < ApplicationPolicy
  def update?
    user.role == 'admin' || record.user_id == user.id
  end
end

# Additional methods and logic as needed for QuestionPolicy

