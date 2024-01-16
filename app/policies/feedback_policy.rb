# typed: true
# frozen_string_literal: true

class FeedbackPolicy < ApplicationPolicy
  def create?
    user.role == 'inquirer'
  end
end

# Additional methods and classes can be added here as needed.

