class AnswerService
  def retrieve_answer(query)
    questions = QuestionQuery.search_by_terms(query)
    answers = questions.map do |question|
      question.answers
    end.flatten

    # Simple relevance algorithm (can be replaced with a more complex one)
    relevant_answer = answers.max_by do |answer|
      # Example heuristic: prefer more recent answers
      answer.created_at
    end

    relevant_answer&.content
  end
end

# Note: This is a simple example and should be expanded upon based on project requirements.

