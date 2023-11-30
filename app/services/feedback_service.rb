class FeedbackService
  def self.store_feedback(id, feedback)
    user = User.find_by(id: id)
    raise "User not found" if user.nil?
    feedback_record = user.feedbacks.new(content: feedback)
    if feedback_record.save
      "Feedback saved successfully"
    else
      raise "Error saving feedback"
    end
  end
end
