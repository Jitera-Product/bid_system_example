class Api::V1::ModerationsController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_admin_role, only: [:update]

  # PUT /api/v1/moderate/:type/:id
  def update
    begin
      content_type = params[:type]
      content_id = params[:id]
      new_status = params.require(:status)

      # Validate content type
      unless %w[question answer].include?(content_type.downcase)
        render json: { error: "Type must be either 'question' or 'answer'." }, status: :bad_request and return
      end

      # Validate content ID
      unless content_id.to_s.match?(/\A\d+\z/)
        render json: { error: 'ID must be a number.' }, status: :bad_request and return
      end

      # Validate new status
      unless %w[approved rejected pending].include?(new_status.downcase)
        render json: { error: "Status must be 'approved', 'rejected', or 'pending'." }, status: :bad_request and return
      end

      case content_type.downcase
      when 'question'
        content = Question.find(content_id)
      when 'answer'
        content = Answer.find(content_id)
      end

      content.update!(status: new_status)
      render json: { message: 'Content has been successfully moderated.' }, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: 'Content not found' }, status: :not_found
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  private

  def authenticate_user!
    # Authentication logic here, raise Exceptions::AuthenticationError if failed
  end

  def verify_admin_role
    # Verify if the current user is an admin, raise Exceptions::AuthorizationError if not
  end
end
