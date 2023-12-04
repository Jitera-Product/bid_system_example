class Api::NotificationsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index filter get_notifications]
  def index
    user_id = params[:user_id]
    unless UserIdValidator.new(user_id).valid?
      render json: { error: 'Invalid user_id' }, status: :unprocessable_entity
      return
    end
    begin
      notifications, total_notifications, total_categories = NotificationsService.new.get_notifications(user_id)
      render json: { notifications: notifications, total_notifications: total_notifications, total_categories: total_categories }, status: :ok
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
  def filter
    activity_type = params[:activity_type]
    unless ActivityTypeValidator.new(activity_type).valid?
      render json: { error: 'Invalid activity type.' }, status: :bad_request
      return
    end
    begin
      notifications = NotificationService.new.filter_notifications(current_user.id, activity_type)
      render json: { status: 200, notifications: notifications }, status: :ok
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
  def get_notifications
    user_id = params[:user_id]
    unless UserIdValidator.new(user_id).valid?
      render json: { error: 'Invalid user_id' }, status: :unprocessable_entity
      return
    end
    begin
      notifications = NotificationsService.new.get_notifications(user_id)
      render json: { status: 200, notifications: notifications }, status: :ok
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
  rescue_from StandardError do |exception|
    render json: { error: exception.message }, status: :internal_server_error
  end
end
