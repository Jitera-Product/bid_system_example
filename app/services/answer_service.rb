class AnswerService
  def get_answer(question_id)
    begin
      # Check if question_id is a number
      raise "Wrong format" unless question_id.is_a? Numeric
      # Find the question
      question = Question.find(question_id)
      # Get the associated answer
      answer = question.answers.first
      # Return the answer
      return { status: 200, answer: answer }
    rescue ActiveRecord::RecordNotFound => e
      # Return error message if question not found
      return { status: 422, error: "This question is not found" }
    rescue Exception => e
      # Return error message for any other exceptions
      return { status: 500, error: e.message }
    end
  end
end
