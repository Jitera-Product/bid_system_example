# frozen_string_literal: true

class QuestionMatchingService
  def match_question(query)
    terms = NlpParserService.new.parse(query)
    matching_questions = Question.search_by_terms(terms)
    selected_answer = AnswerSelectionService.new.select_best_answer(matching_questions)

    { answer_content: selected_answer.content, answer_id: selected_answer.id }
  end
end

# Additional code for Question model
class Question < ApplicationRecord
  scope :search_by_terms, ->(terms) {
    where('title ILIKE ANY (array[?]) OR content ILIKE ANY (array[?])', terms, terms)
  }
end

# Additional code for AnswerSelectionService
class AnswerSelectionService
  def select_best_answer(questions)
    # Logic to select the best answer based on relevance and feedback data
  end
end
