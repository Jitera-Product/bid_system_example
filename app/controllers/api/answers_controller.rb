# typed: ignore
module Api
  class AnswersController < BaseController
    before_action :authenticate_user!
    before_action :set_answer, only: [:update]
    before_action :authorize_answer!, only: [:update]
    before_action :validate_content, only: [:update]

    # New search action from existing code
    def search
      query = params[:query]
      if query.blank?
        render json: { status: 400, message: "The query is required." }, status: :bad_request
      else
        search_service = SearchService.new
        answers = search_service.search_answers_for_query(query)
        render json: { status: 200, answers: answers }, status: :ok
      end
    rescue StandardError => e
      render json: { status: 500, message: e.message }, status: :internal_server_error
    end

    # Updated update action combining new and existing code
    def update
      if @answer.update(answer_params)
        render json: { status: 200, message: I18n.t('answers.update.success'), answer: @answer }, status: :ok
      else
        render json: { status: 422, errors: @answer.errors.full_messages }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordInvalid => e
      render json: { status: 422, error: error_response(@answer, e) }, status: :unprocessable_entity
    rescue Pundit::NotAuthorizedError => e
      render json: { status: 401, error: error_response(nil, e) }, status: :unauthorized
    end

    private

    # Combined set_answer method from new and existing code
    def set_answer
      @answer = Answer.find_by(id: params[:id], question_id: params[:question_id])
      render json: { status: 404, message: I18n.t('answers.update.not_found') }, status: :not_found unless @answer
    end

    # authorize_answer! method remains unchanged as it is identical in both versions
    def authorize_answer!
      raise Pundit::NotAuthorizedError unless current_user.contributor? && @answer.user_id == current_user.id
    end

    # Combined validate_content method from new and existing code
    def validate_content
      content = params.dig(:answer, :content)
      if content.blank?
        render json: { status: 422, message: I18n.t('answers.update.invalid_content') }, status: :unprocessable_entity
      elsif !content_meets_guidelines?(content)
        render json: { status: 400, message: I18n.t('answers.update.invalid_content_format') }, status: :bad_request
      end
    end

    # content_meets_guidelines? method remains unchanged as it is identical in both versions
    def content_meets_guidelines?(content)
      # Assuming there's a method to validate content against guidelines
      # This is a placeholder for actual content guideline validation logic
      content.length > 10 # Example condition: content should be more than 10 characters
    end

    # answer_params method remains unchanged as it is identical in both versions
    def answer_params
      params.require(:answer).permit(:content)
    end
  end
end
