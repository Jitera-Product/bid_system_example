# typed: true
# frozen_string_literal: true

class QuestionPolicy < ApplicationPolicy
  attr_reader :user

  def initialize(user, record = nil)
    @user = user
    @record = record
  end

  def create?
    user.role == 'Contributor'
  end

  def update?
    user.role == 'admin' || record.user_id == user.id
  end

  # Include any other methods from the existing QuestionPolicy here
end
