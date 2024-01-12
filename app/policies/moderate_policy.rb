# typed: true
# frozen_string_literal: true

class ModeratePolicy < ApplicationPolicy
  def update?
    user.role == 'Administrator'
  end
end

# Additional methods and classes can be added here if necessary
