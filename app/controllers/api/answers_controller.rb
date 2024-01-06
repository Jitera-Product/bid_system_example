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

    private

    def log_inquiry_and_response(question_text, answers)
      Rails.logger.info "Question asked: #{question_text}, Answers provided: #{answers.map(&:answer_text)}"
    end

    def format_answers(answers)
      answers.map { |answer| { answer_text: answer.answer_text, question_id: answer.question_id, metadata: answer.metadata } }
    end
  end
end
