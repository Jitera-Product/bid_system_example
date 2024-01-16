# typed: true
# frozen_string_literal: true

module Api
  class FeedbackPolicy < ApplicationPolicy
    def create?
      user.role == 'inquirer'
    end
  end
end

