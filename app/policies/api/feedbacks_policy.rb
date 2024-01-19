# typed: true
# frozen_string_literal: true

class FeedbacksPolicy < ApplicationPolicy
  def inquirer?
    user.role == 'inquirer'
  end

  def create?
    inquirer?
  end
end
