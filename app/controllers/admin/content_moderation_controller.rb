# typed: ignore
module Admin
  class ContentModerationController < Api::BaseController
    before_action :authenticate_admin!
    before_action :set_moderatable, only: [:moderate_content]
    before_action :validate_moderation_input, only: [:moderate_content]

    def moderate_content
      action = params[:action]
      case action
      when 'approve'
        approve_content
      when 'reject'
        reject_content
      when 'edit'
        edit_content
      else
        render json: { message: 'Invalid action' }, status: :bad_request
      end
    rescue ActiveRecord::RecordNotFound => e
      render json: { message: e.message }, status: :not_found
    rescue StandardError => e
      render json: error_response(nil, e), status: :internal_server_error
    end

    private

    def authenticate_admin!
      # Assuming there's a method `admin?` in the user model to check if the user is an admin.
      moderator = User.find_by(id: params[:moderator_id])
      render json: { message: 'Unauthorized' }, status: :unauthorized unless moderator&.admin?
    end

    def set_moderatable
      # Validate the table_name parameter to ensure it corresponds to a valid model
      unless ['Question', 'Answer'].include?(params[:table_name])
        render json: { message: 'Invalid table name' }, status: :bad_request and return
      end

      @moderatable = params[:table_name].constantize.find_by(id: params[:submission_id])
      render json: { message: 'Record not found' }, status: :not_found unless @moderatable
    end

    def validate_moderation_input
      missing_params = %w[submission_id moderator_id action].select { |param| params[param].blank? }
      unless missing_params.empty?
        render json: { message: "Missing parameters: #{missing_params.join(', ')}" }, status: :bad_request
      end
    end

    def approve_content
      @moderatable.approve!
      record_moderation_activity('approve')
      render json: { message: 'Content approved', submission_id: @moderatable.id }
    end

    def reject_content
      @moderatable.reject!
      record_moderation_activity('reject')
      render json: { message: 'Content rejected', submission_id: @moderatable.id }
    end

    def edit_content
      raise ArgumentError, 'New content not provided' unless params[:content].present?
      @moderatable.edit!(params[:content])
      record_moderation_activity('edit')
      render json: { message: 'Content edited', submission_id: @moderatable.id }
    end

    def record_moderation_activity(action)
      # Assuming there's a UserActivity model with a method `create!`.
      UserActivity.create!(
        user_id: params[:moderator_id],
        activity_type: action,
        activity_description: "Moderated content with ID: #{params[:submission_id]}",
        action: action,
        timestamp: Time.current
      )
    end
  end
end
