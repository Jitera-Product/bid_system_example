# typed: ignore
module Api
  class AnswersController < BaseController
    before_action :authenticate_user!

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
    # Enhanced search method to include intent and context in the search
    # New search method
    def search
      query = params[:query]
      return render json: { error: 'Query cannot be empty.' }, status: :bad_request if query.blank?

      parsed_query = NlpService.parse(query)
      similar_questions = QuestionService::Index.new(parsed_query).call
      if similar_questions.present?
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

      Rails.logger.info "Question asked: #{question_text}, Answers provided: #{answers.map(&:answer_text).join(', ')}"
      Rails.logger.info "Question asked: #{question_text}, Answers provided: #{answers.map(&:answer_text)}"
    end

    def format_answers(answers)
      answers.map do |answer|
        {
          id: answer.id,
          question_id: answer.question_id,
          created_at: answer.created_at.iso8601,
          feedback_score: answer.feedback_score
          created_at: answer.created_at.iso8601
        }
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
end
