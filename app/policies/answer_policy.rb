# typed: true
# frozen_string_literal: true

class AnswerPolicy < ApplicationPolicy
  def update?
    user.admin? || answer.user_id == user.id
  end

  private

  attr_reader :answer
end
