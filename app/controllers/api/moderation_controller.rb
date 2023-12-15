# typed: ignore
module Api
  class ModerationController < BaseController
    include OauthTokensConcern
    before_action :authenticate_user!
    before_action :validate_admin_role

    def index
      validate_moderation_params(params[:type], params[:status])

      content = ModerationService.new(params[:type], params[:status]).moderate
      render json: { status: 200, content: content }, status: :ok
    rescue StandardError => e
      render_error(e)
    end

    # New update method to handle moderation update requests
    def update
      moderation_id = params[:id]
      status = params.require(:status)

      validate_moderation_update_params(moderation_id, status)

      moderation = ModerationService.new(moderation_id, status).update_status
      render json: { status: 200, moderation: moderation }, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { message: 'Content not found.' }, status: :not_found
    rescue StandardError => e
      render_error(e)
    end

    private

    # Existing validation method for index action
    def validate_moderation_params(type, status)
      valid_types = ['question', 'answer']
      valid_statuses = ['pending', 'approved', 'rejected']
      unless valid_types.include?(type)
        render json: { message: "Type must be either 'question' or 'answer'." }, status: :bad_request and return
      end
      unless valid_statuses.include?(status)
        render json: { message: "Invalid status type." }, status: :bad_request and return
      end
    end

    # New validation method for update action
    def validate_moderation_update_params(id, status)
      valid_statuses = ['pending', 'approved', 'rejected']
      unless ModerationQueue.exists?(id: id)
        render json: { message: 'Content not found.' }, status: :not_found and return
      end
      unless valid_statuses.include?(status)
        render json: { message: "Invalid status value." }, status: :bad_request and return
      end
    end

    def validate_admin_role
      unless current_user.admin?
        render json: { message: 'You must be an administrator to perform this action' }, status: :unauthorized
      end
    end

    def render_error(e)
      case e
      when ActiveRecord::RecordNotFound
        render json: { message: e.message }, status: :not_found
      when Pundit::NotAuthorizedError, Exceptions::AuthenticationError
        render json: { message: e.message }, status: :unauthorized
      else
        render json: { message: e.message }, status: :internal_server_error
      end
    end
  end
end
