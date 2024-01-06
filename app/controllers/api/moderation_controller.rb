module Api
  class ModerationController < BaseController
    before_action :authenticate_admin, only: [:update]
    before_action :authenticate_user!
    before_action :authorize_admin, only: [:update]

    def update
      id = params[:id]
      content_type = params[:content_type]
      status = params[:status]
      admin_id = params[:admin_id]

      unless authenticate_admin(admin_id)
        return render json: { error: 'Unauthorized: Admin only action.' }, status: :unauthorized
      end

      content = find_content(content_type, id)
      return render json: { error: 'Content not found.' }, status: :not_found if content.nil?

      moderation_status = case params[:action]
                          when 'approve'
                            approve_content(content)
                          when 'reject'
                            reject_content(content)
                          else
                            'invalid_action'
                          end

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

    def authenticate_admin(admin_id)
      User.find_by(id: admin_id)&.role == 'admin'
    end

    def find_content(content_type, id)
      case content_type
      when 'question'
        Question.find_by_id(id)
      when 'answer'
        Answer.find_by_id(id)
      else
        nil
      end
    end

    def approve_content(content)
      content.update(status: 'approved')
      'approved'
    end

    def reject_content(content)
      content.update(status: 'rejected')
      'rejected'
    end

    private

    def authorize_admin
      render json: { error: 'Unauthorized' }, status: :unauthorized unless current_user.admin?
    end
  end
end
