# typed: ignore
module Api
  class ChatSessionsController < BaseController
    before_action :doorkeeper_authorize!
    rescue_from ActiveRecord::RecordNotFound, with: :base_render_record_not_found

    def disable
      chat_session = ChatSession.find(params[:id])
      if chat_session.bid_item.status_done?
        chat_session.is_active = false
        chat_session.updated_at = Time.current
        chat_session.save!
        render 'api/chat_sessions/disable', status: :ok
      else
        render json: { message: I18n.t('common.errors.unauthorized_error') }, status: :forbidden
      end
    end

    private

    def base_render_record_not_found(_exception)
      render json: { message: I18n.t('common.404') }, status: :not_found
    end
  end
end
