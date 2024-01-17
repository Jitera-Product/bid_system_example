# frozen_string_literal: true

module Api
  class FeedbackPolicy < ApplicationPolicy
    def create?
      inquirer? && answer_exists? && user_exists? && valid_usefulness?
    end

    private

    def inquirer?
      user.role == 'inquirer'
    end

    def answer_exists?
      Answer.exists?(id: record.answer_id)
    end

    def user_exists?
      User.exists?(id: record.user_id)
    end

    def valid_usefulness?
      ['helpful', 'not_helpful', 'neutral'].include?(record.usefulness)
    end
  end
end
