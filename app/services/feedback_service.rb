class FeedbackService
  def initialize; end
  def create_feedback(content, inquirer_id, answer_id)
    # Validate the input data
    FeedbackValidator.new(content: content, inquirer_id: inquirer_id, answer_id: answer_id).validate!
    # Check if the inquirer_id and answer_id exist in the database
    raise "Inquirer not found" unless User.exists?(inquirer_id)
    raise "Answer not found" unless Answer.exists?(answer_id)
    # Create a new feedback record in the database
    feedback = Feedback.create!(content: content, inquirer_id: inquirer_id, answer_id: answer_id)
    # Send a confirmation message to the inquirer
    confirmation_message = FeedbackMailer.send_confirmation(inquirer_id, feedback.id)
    # Return the feedback id and the confirmation message
    { feedback_id: feedback.id, confirmation_message: confirmation_message }
  end
end
