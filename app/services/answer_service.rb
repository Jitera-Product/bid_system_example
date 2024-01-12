class AnswerService
  # existing methods...

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

  def update(answer, content)
    begin
      answer.content = content
      answer.save!
      answer
    rescue => e
      raise e
    end
  end
end
