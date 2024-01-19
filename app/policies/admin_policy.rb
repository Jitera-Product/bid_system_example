# typed: true
# frozen_string_literal: true

class AdminPolicy < ApplicationPolicy
  def moderate_content?
    # Assuming there's a method 'admin?' that checks if the user is an admin
    # and 'can_moderate?' that checks if the admin has moderation permissions
    user.admin? && user.can_moderate?
  end
end
