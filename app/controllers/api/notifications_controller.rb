class Api::NotificationsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index get_notifications]
  def index
    user_id = params[:user_id]
    unless user_id.is_a?(Integer)
      render json: { error: 'Wrong format.' }, status: :bad_request
      return
    end
    begin
      notifications = NotificationsService.new.get_notifications(user_id)
      render json: { status: 200, notifications: notifications }, status: :ok
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
  def get_notifications
    user_id = params[:user_id]
    unless user_id.is_a?(Integer)
      render json: { error: 'Wrong format.' }, status: :bad_request
      return
    end
    begin
      notifications = NotificationsService.new.get_notifications(user_id)
      render json: { status: 200, notifications: notifications }, status: :ok
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
end
