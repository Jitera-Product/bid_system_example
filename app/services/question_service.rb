# frozen_string_literal: true

class QuestionService
  def initialize(nlp_processor = NlpProcessor)
    @nlp_processor = nlp_processor
  end

  def retrieve_answer(query)
    key_terms = @nlp_processor.extract_key_terms(query)
    questions = QuestionQuery.search_by_terms(key_terms)
    most_relevant_question = select_most_relevant_question(questions)
    return nil unless most_relevant_question

    answers = most_relevant_question.answers
    most_relevant_answer = select_most_relevant_answer(answers)
    most_relevant_answer&.content
  end

  private

  def select_most_relevant_question(questions)
    # Implement relevance algorithm to select the most relevant question
  end

  def select_most_relevant_answer(answers)
    # Implement relevance algorithm to select the most relevant answer
  end
end
