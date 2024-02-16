# typed: true
# frozen_string_literal: true

class ModerPolicy < ApplicationPolicy
  # This policy is for moder actions, particularly for the signup action.
  # Since signup should be allowed for unauthenticated users, we don't need to check for a logged-in user here.
  
  def signup?
    true # Anyone can sign up, no user needed to be present
  end

  # Define other necessary authorization rules for moders if needed

  # ... (other methods and rules can be added here as needed)
end
