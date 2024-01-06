
class QuestionRetrievalService
  # Existing methods...

  def retrieve_answer(question_text)
    nlp_data = NlpService.parse(question_text)
    similar_questions = find_similar_questions(nlp_data)
    answer = select_best_answer(similar_questions)
    log_inquiry_and_response(question_text, answer)
    answer&.answer_text || 'Sorry, no answer could be found for your question.'
  rescue StandardError => e
    logger.error "Error retrieving answer: #{e.message}"
    'An error occurred while retrieving the answer. Please try again later.'
  end

  def find_similar_questions(nlp_data)
    intent = nlp_data[:intent]
    context = nlp_data[:context]

    # Assuming 'question_text' is the column to perform full-text search on
    # and 'intent' and 'context' are used to refine the search.
    # This is a simple example using basic ActiveRecord querying methods.
    # Depending on the database used, you might need to use specific full-text search features.
    Question.where('question_text LIKE ?', "%#{intent}%")
            .or(Question.where('question_text LIKE ?', "%#{context}%"))
            .limit(10) # Limiting the result for the sake of performance
  end

  private

  def select_best_answer(questions)
    questions.includes(:answers)
             .map(&:answers)
             .flatten
             .max_by { |answer| answer.feedback_score }
  end

  def log_inquiry_and_response(question_text, answer)
    logger.info "Question: #{question_text}, Answer: #{answer&.answer_text}"
  end
end
