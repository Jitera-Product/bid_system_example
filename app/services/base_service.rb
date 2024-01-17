# typed: true
class BaseService
  def initialize(*_args); end

  def logger
    @logger ||= Rails.logger
  end

  def retrieve_answers(question_content)
    questions = Question.search_by_content(question_content)
    answers_with_question_id = questions.map do |question|
      {
        question_id: question.id,
        answers: question.answers.sort_by(&:created_at) # Assuming relevance is based on the creation date for this example
      }
    end
    answers_with_question_id
  end
end
