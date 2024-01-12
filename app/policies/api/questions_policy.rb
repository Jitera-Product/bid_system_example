# typed: true
# frozen_string_literal: true

class Api::QuestionsPolicy < ApplicationPolicy
  def update?
    user.admin?
  end
end

# Additional methods and logic can be added here as needed.
