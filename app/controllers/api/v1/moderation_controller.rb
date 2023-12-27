class Api::V1::ModerationController < Api::BaseController
  before_action :authenticate_user!
  before_action :check_admin_role
  before_action :validate_moderation_input, only: [:update]
  before_action :set_moderatable, only: [:update]

  # PUT /api/v1/moderate
  def update
    action = params[:action]
    moderator_id = params[:moderator_id]

    # Validate moderator
    unless User.exists?(id: moderator_id, role: 'Administrator')
      render json: { error: 'Invalid moderator ID or not an administrator.' }, status: :unprocessable_entity
      return
    end

    case action
    when 'approve', 'reject', 'edit'
      # Perform the corresponding moderation action
      if action == 'edit' && params[:content].blank?
        render json: { error: 'Content is required for edit action.' }, status: :unprocessable_entity
        return
      end

      if @moderatable.update(moderation_params(action))
        # Log the moderation action
        UserActivity.create(
          user_id: moderator_id,
          activity_type: 'moderation',
          activity_description: "Moderation action '#{action}' performed on #{@moderatable.class.name} with ID: #{params[:submission_id]}",
          action: action,
          timestamp: Time.current
        )

        render json: { message: "Content has been successfully #{action}d" }, status: :ok
      else
        render json: { errors: @moderatable.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Invalid action.' }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Content not found.' }, status: :not_found
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  private

  def check_admin_role
    render json: { error: 'Forbidden' }, status: :forbidden unless current_user.role == 'Administrator'
  end

  def validate_moderation_input
    required_params = %w[submission_id moderator_id action]
    missing_params = required_params.select { |param| params[param].blank? }
    unless missing_params.empty?
      render json: { error: "Missing parameters: #{missing_params.join(', ')}" }, status: :unprocessable_entity
    end
  end

  def set_moderatable
    submission_id = params[:submission_id]
    case params[:type]
    when 'question'
      @moderatable = Question.find(submission_id)
    when 'answer'
      @moderatable = Answer.find(submission_id)
    else
      render json: { error: 'Invalid type specified.' }, status: :unprocessable_entity
      return
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Content not found.' }, status: :not_found
  end

  def moderation_params(action)
    case action
    when 'approve'
      { status: 'approved' }
    when 'reject'
      { status: 'rejected', reason: params[:reason] }
    when 'edit'
      { content: params[:content] }
    else
      {}
    end
  end
end
