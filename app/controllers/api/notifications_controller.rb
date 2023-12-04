class Api::NotificationsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index]
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
end
