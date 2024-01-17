# typed: true
# frozen_string_literal: true

module Api
  class AnswersPolicy
    def initialize(user)
      @user = user
    end

    def create?
      @user.role == 'contributor'
    end
  end
end
