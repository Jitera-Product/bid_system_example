
class FeedbackService
  def self.create_feedback(comment:, usefulness:, answer_id:)
    raise ActiveRecord::RecordNotFound unless Answer.exists?(answer_id)

    sanitized_comment = ActiveRecord::Base.sanitize_sql(comment)

    Feedback.transaction do
      feedback = Feedback.create!(comment: sanitized_comment, usefulness: usefulness, answer_id: answer_id)
      # Optional: Update answer's ranking logic here
      feedback
    rescue ActiveRecord::RecordInvalid => e
      raise e
    end
  end

  # ... other methods ...
end
