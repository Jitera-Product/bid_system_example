# typed: ignore
module Api
  class AnswersController < BaseController
    before_action :authenticate_user!
    before_action :authorize_user, only: [:search]

    def retrieve_answer
      # Extract intent and context from the question using NlpService
      question_text = params[:question_text]
      parsed_question = NlpService.parse(question_text)
      intent, context = parsed_question.values_at(:intent, :context)
      similar_questions = QuestionService::Index.new(intent: intent, context: context).call

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

    def search
      query = params[:query]
      if query.blank?
        return render json: { error: 'Query is required.' }, status: :bad_request
      end

      begin
        parsed_query = NlpService.parse(query)
        similar_questions = QuestionService::Index.new(intent: parsed_query[:intent], context: parsed_query[:context]).call
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
    end

    private

    def authorize_user
      unless Api::UsersPolicy.new(current_user).allowed_to_view_answers?
        render json: { error: 'Forbidden' }, status: :forbidden
      end
    end

    def format_answers(answers)
      answers.map do |answer|
        {
          id: answer.id,
          question_id: answer.question_id,
          created_at: answer.created_at.iso8601,
          answer_text: answer.answer_text,
          feedback_score: answer.feedback_score
        }
      end
    end

    def log_inquiry_and_response(question_text, answers)
      Rails.logger.info "Question asked: #{question_text}, Answers provided: #{answers.map(&:answer_text)}"
    end

    # Method to select the best answer based on relevance and feedback scores
    def select_best_answer(answers)
      answers.max_by { |answer| [answer.relevance_score, answer.feedback_score] }
    end

    # Format the response to include only the answer_text of the selected answer
    def format_best_answer(answer)
      { answer_text: answer.answer_text }
    end
  end
end
