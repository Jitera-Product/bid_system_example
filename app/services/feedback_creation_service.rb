# typed: true
class FeedbackCreationService < BaseService
  include Pundit

  def create_feedback(answer_id, user_id, score, comment)
    # Authenticate the user and check if they have the 'Inquirer' role
    user = User.find_by(id: user_id)
    raise Pundit::NotAuthorizedError, 'User not authenticated or not an Inquirer' unless user && policy(user).inquirer?

    # Validate the input data
    validate_input_data(answer_id, user_id, score)

    # Check if the answer and user records exist
    answer = Answer.find_by(id: answer_id)
    raise 'Answer not found' unless answer
    raise 'User not found' unless user

    # Create a new Feedback record
    feedback = Feedback.create!(
      answer_id: answer_id,
      user_id: user_id,
      score: score,
      comment: comment
    )

    # Update the feedback_score attribute of the associated Answer record
    update_answer_feedback_score(answer)

    { message: 'Feedback successfully recorded', feedback: feedback }
  rescue Pundit::NotAuthorizedError => e
    logger.error "FeedbackCreationService Authorization Error: #{e.message}"
    raise e
  rescue StandardError => e
    logger.error "FeedbackCreationService Error: #{e.message}"
    raise e
  end

  private

  def policy(user)
    # Assuming that the Pundit policy for users is already defined
    UserPolicy.new(nil, user)
  end

  def validate_input_data(answer_id, user_id, score)
    raise 'Answer ID, User ID, and Score are required' if answer_id.blank? || user_id.blank? || score.blank?
    raise 'Score must be an integer between 1 and 5' unless score.is_a?(Integer) && score.between?(1, 5)
  end

  def update_answer_feedback_score(answer)
    feedback_scores = answer.feedbacks.pluck(:score)
    answer.update(feedback_score: feedback_scores.sum.to_f / feedback_scores.size)
  end
end
