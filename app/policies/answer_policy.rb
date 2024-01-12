# typed: true
# frozen_string_literal: true

class AnswerPolicy < ApplicationPolicy
  def edit?
    user.is_a?(User) && user.role == 'Contributor' && user.id == answer.contributor_id
  end

  private

  attr_reader :answer
end
