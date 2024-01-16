
class FeedbackService
  def create_feedback(answer_id, user_id, comment, usefulness)
    user = User.find(user_id)
    raise 'User does not have inquirer role' unless UsersPolicy.new(user).check_inquirer_role(user)

    answer = Answer.find(answer_id)
    raise 'Answer does not exist' if answer.nil?

    raise 'Invalid usefulness value' unless Feedback.usefulnesses.keys.include?(usefulness)

    feedback = Feedback.create!(
      answer_id: answer_id,
      user_id: user_id,
      comment: comment,
      usefulness: usefulness
    )

    # Update AI response accuracy logic goes here

    'Feedback has been recorded'
  end
end
