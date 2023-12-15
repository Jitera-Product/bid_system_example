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

    private

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
