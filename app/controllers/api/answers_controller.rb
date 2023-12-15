# typed: ignore
module Api
  class AnswersController < BaseController
    before_action :authenticate_user!
    before_action :set_answer, only: [:update]
    before_action :authorize_answer!, only: [:update]
    before_action :validate_content, only: [:update]

    def update
      if @answer.update(answer_params)
        render json: { message: I18n.t('answers.update.success'), answer: @answer }, status: :ok
      else
        render json: { message: @answer.errors.full_messages }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordInvalid => e
      render json: error_response(@answer, e), status: :unprocessable_entity
    rescue Pundit::NotAuthorizedError => e
      render json: error_response(nil, e), status: :unauthorized
    end

    private

    def set_answer
      @answer = Answer.find_by(id: params[:id], question_id: params[:question_id])
      render json: { message: I18n.t('answers.update.not_found') }, status: :not_found unless @answer
    end

    def authorize_answer!
      raise Pundit::NotAuthorizedError unless current_user.contributor? && @answer.user_id == current_user.id
    end

    def validate_content
      content = params.dig(:answer, :content)
      if content.blank? || !content_meets_guidelines?(content)
        render json: { message: I18n.t('answers.update.invalid_content') }, status: :unprocessable_entity
      end
    end

    def content_meets_guidelines?(content)
      # Assuming there's a method to validate content against guidelines
      # This is a placeholder for actual content guideline validation logic
      content.length > 10 # Example condition: content should be more than 10 characters
    end

    def answer_params
      params.require(:answer).permit(:content)
    end
  end
end
