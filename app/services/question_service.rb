class QuestionService
  def submit_question(content, user_id, category)
    # Validate input data
    QuestionValidator.new(content: content, user_id: user_id, category: category).validate
    # Create new question
    question = Question.create!(content: content, user_id: user_id, category: category)
    # Send confirmation email
    QuestionMailer.question_confirmation(user_id, question.id).deliver_now
    # Return question id and confirmation message
    { question_id: question.id, message: 'Question submitted successfully and confirmation email sent.' }
  end
  def update_question(id, content, user_id, category)
    # Validate input data
    QuestionValidator.new(id: id, content: content, user_id: user_id, category: category).validate
    # Find the question
    question = Question.find_by(id: id)
    # Raise an exception if the question does not exist
    raise ActiveRecord::RecordNotFound, "This question is not found" if question.nil?
    # Update the question's content, user_id, and category
    question.update!(content: content, user_id: user_id, category: category)
    # Return the updated question
    question
  end
end
