class Api::V1::ModerationController < Api::BaseController
  before_action :authenticate_user!
  before_action :check_admin_role
  before_action :set_moderatable, only: [:update]

  # PUT /api/moderate/:type/:id
  def update
    status = params[:status]

    unless %w[approved rejected pending].include?(status)
      render json: { error: 'Invalid status value.' }, status: :unprocessable_entity
      return
    end

    if @moderatable.update(status: status)
      render json: { message: 'Content has been successfully moderated' }, status: :ok
    else
      render json: { errors: @moderatable.errors.full_messages }, status: :unprocessable_entity
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

  def set_moderatable
    case params[:type]
    when 'question'
      @moderatable = Question.find(params[:id])
    when 'answer'
      @moderatable = Answer.find(params[:id])
    else
      render json: { error: 'Invalid type specified.' }, status: :unprocessable_entity
      return
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Content not found.' }, status: :not_found
  end
end
