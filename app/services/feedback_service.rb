class FeedbackService
  def self.store_feedback(user_id, match_id, feedback)
    raise "Wrong format" unless user_id.is_a?(Integer) && match_id.is_a?(Integer)
    raise "The feedback is required." if feedback.blank?
    user = User.find_by(id: user_id)
    raise "This user is not found" if user.nil?
    match = Match.find_by(id: match_id)
    raise "This match is not found" if match.nil?
    feedback_record = user.feedbacks.new(content: feedback, match_id: match.id)
    if feedback_record.save
      feedback_record
    else
      raise "Error saving feedback"
    end
  end
end
