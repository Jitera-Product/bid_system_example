# typed: true
module Api
  class ModerateController < BaseController
    before_action :authenticate_user!
    before_action :check_admin_role, only: [:update_status]

    def update_status
      type = params[:type]
      id = params[:id].to_i
      status = params[:status]

      case type
      when 'question'
        content = Question.find_by(id: id)
        authorize content, :moderate?
      when 'answer'
        content = Answer.find_by(id: id)
        authorize content, :moderate?
      else
        return render json: { error: 'Invalid type for moderation.' }, status: :bad_request
      end

      return render json: { error: 'Content not found.' }, status: :not_found unless content

      unless %w[approved rejected].include?(status)
        return render json: { error: 'Invalid status value.' }, status: :bad_request
      end

      if content.moderate!(status)
        render json: { message: 'Content has been successfully moderated.' }, status: :ok
      else
        render json: { errors: content.errors.full_messages }, status: :unprocessable_entity
      end
    rescue Pundit::NotAuthorizedError => e
      render json: { error: e.message }, status: :unauthorized
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end

    private

    def check_admin_role
      render json: { error: 'User is not an administrator.' }, status: :unauthorized unless current_user.admin?
    end
  end
end
