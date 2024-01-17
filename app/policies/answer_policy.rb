# typed: true
# frozen_string_literal: true

class AnswerPolicy < ApplicationPolicy
  def update?
    user.admin? || answer.user_id == user.id
  end

  def create?
    user.contributor?
  end

  def search?
    user.role == 'inquirer'
  end

  def moderate?
    user.admin?
  end

  private

  attr_reader :answer
end
