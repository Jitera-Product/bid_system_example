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
end
