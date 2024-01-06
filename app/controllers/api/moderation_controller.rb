module Api
  class ModerationController < BaseController
    before_action :authenticate_user!
    before_action :authorize_admin, only: [:update]

    def update
      id = params[:id]
      content_type = params[:content_type]
      status = params[:status]

      return render json: { error: 'Invalid status value.' }, status: :bad_request unless ['approved', 'rejected'].include?(status)

      case content_type
      when 'question'
        service = QuestionService.new
        record = Question.find_by_id(id)
      when 'answer'
        service = AnswerService.new
        record = Answer.find_by_id(id)
      else
        return render json: { error: 'Invalid content type.' }, status: :bad_request
      end

      return render json: { error: 'Invalid ID for the specified content type.' }, status: :bad_request if record.nil?

      if service.moderate_content(id, status)
        render json: { message: 'Content has been successfully moderated.' }, status: :ok
      else
        render json: { error: 'Content update failed' }, status: :unprocessable_entity
      end
    rescue StandardError => e
      Rails.logger.error "Error updating content: #{e.message}"
      render json: { error: e.message }, status: :internal_server_error
    end

    private

    def authorize_admin
      render json: { error: 'Unauthorized' }, status: :unauthorized unless current_user.admin?
    end
  end
end
