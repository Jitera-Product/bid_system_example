
# frozen_string_literal: true

class QueryLoggerService
  def self.log_query(query, answers)
    # Logic to log the query and answers
  end
end

class QuestionMatchingService
  def match_question(query)
    terms = NlpParserService.new.parse(query)
    matching_questions = Question.search_by_terms(terms)
    answers = AnswerSelectionService.new.select_best_answers(matching_questions)

    QueryLoggerService.log_query(query, answers)
    answers.map do |answer|
      { answer_content: answer.content, answer_id: answer.id }
    end
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
  def select_best_answers(questions)
    # Logic to select the best answers based on relevance and feedback data
    # Implement ranking mechanism here
  end
end
