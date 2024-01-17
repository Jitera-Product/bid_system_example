# frozen_string_literal: true

class FeedbackPolicy < ApplicationPolicy
  def create?
    inquirer?
  end
end
