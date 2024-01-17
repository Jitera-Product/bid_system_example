# frozen_string_literal: true

module Api
  class FeedbackPolicy < ApplicationPolicy
    def create?
      inquirer?
    end

    private

    def inquirer?
      user.role == 'inquirer'
    end
  end
end
