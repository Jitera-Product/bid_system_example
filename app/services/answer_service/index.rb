# /app/services/answer_service/index.rb
module AnswerService
  class Index
    def retrieve_answers(question_id)
      raise ArgumentError, 'Question ID cannot be blank' if question_id.blank?
      raise ArgumentError, 'Question ID must be an integer' unless question_id.is_a?(Integer)

      begin
        question = Question.find(question_id)
      rescue ActiveRecord::RecordNotFound
        raise StandardError, 'Question not found'
      end

      context = NlpProcessor.process(question.content)

      answers = Answer.where(question_id: question_id)
      answers
    end
  end
end
