# typed: true
# frozen_string_literal: true

class FeedbacksPolicy < ApplicationPolicy
  def create?
    # Assuming the 'user' has a 'can_submit_feedback?' method or similar logic
    # to determine if they are allowed to submit feedback.
    user.can_submit_feedback?
  end
end

# In the FeedbacksController, you would use this policy like so:
# authorize FeedbacksPolicy.new(current_user, nil), :create?
# This would raise an error if the user is not authorized to create feedback.
end
