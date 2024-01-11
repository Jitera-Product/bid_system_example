# frozen_string_literal: true

class QuestionRetrievalService
  def retrieve_answers(question_id)
    raise ArgumentError, 'Question ID must be present and an integer' unless question_id.is_a?(Integer)

    begin
      question = Question.find(question_id)
    rescue ActiveRecord::RecordNotFound => e
      raise "Question with ID #{question_id} not found"
    end

    begin
      terms = NlpParserService.new.parse(question.content)
    rescue => e
      # Handle NLP parsing errors
      raise "Failed to parse question content: #{e.message}"
    end

    answers = question.answers
    answers.map do |answer|
      { answer_content: answer.content, answer_id: answer.id }
    end
  rescue => e
    # Log error
    raise "An error occurred while retrieving answers: #{e.message}"
  end
end
