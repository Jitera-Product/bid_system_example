
class Api::V1::AdminsController < ApplicationController
  before_action :doorkeeper_authorize!
  before_action :authorize_admin, only: [:moderate_content]

  # POST /admins/moderate_content
  def moderate_content
    content_id = params.require(:content_id)
    content_type = params.require(:content_type)
    action = params.require(:action)

    content = find_content(content_type, content_id)
    content.update_moderation_status(action)

    log_moderation_action(content, action)

    render json: { message: "Content has been #{action}d." }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'Content not found' }, status: :not_found
  rescue Pundit::NotAuthorizedError
    render json: { message: 'Not authorized to perform this action' }, status: :unauthorized
  rescue ArgumentError => e
    render json: { message: e.message }, status: :unprocessable_entity
  end

  private

  def authorize_admin
    authorize current_resource_owner, policy_class: Api::AdminsPolicy
  end

  def find_content(content_type, content_id)
    content_type == 'question' ? Question.find(content_id) : Answer.find(content_id)
  end

  def log_moderation_action(content, action)
    # Implement logging mechanism here
  end
end
