# typed: ignore
module Api
  class AnswersController < BaseController
    before_action :authenticate_user!

    def retrieve_answer
      question_text = params[:question_text]
      parsed_question = NlpService.parse(question_text)
      similar_questions = QuestionService::Index.new(parsed_question).call

      if similar_questions.any?
        answers = AnswerService::Index.new(similar_questions).call
        log_inquiry_and_response(question_text, answers)
        render json: format_answers(answers), status: :ok
      else
        render json: { error: 'No relevant answers found.' }, status: :not_found
      end
    rescue StandardError => e
      Rails.logger.error "Error retrieving answer: #{e.message}"
      render json: { error: e.message }, status: :internal_server_error
    end

    # New search method
    def search
      query = params[:query]
      return render json: { error: 'Query cannot be empty.' }, status: :bad_request if query.blank?

      parsed_query = NlpService.parse(query)
      similar_questions = QuestionService::Index.new(parsed_query).call

      if similar_questions.any?
        answers = AnswerService::Index.new(similar_questions).call
        render json: { status: 200, answers: format_answers(answers) }, status: :ok
      else
        render json: { error: 'No relevant answers found.' }, status: :not_found
      end
    rescue StandardError => e
      Rails.logger.error "Error searching for answers: #{e.message}"
      render json: { error: e.message }, status: :internal_server_error
    end

    private

    def log_inquiry_and_response(question_text, answers)
      Rails.logger.info "Question asked: #{question_text}, Answers provided: #{answers.map(&:answer_text)}"
    end

    def format_answers(answers)
      answers.map do |answer|
        {
          id: answer.id,
          question_id: answer.question_id,
          answer_text: answer.answer_text,
          created_at: answer.created_at.iso8601
        }
      end
    end
  end
end
