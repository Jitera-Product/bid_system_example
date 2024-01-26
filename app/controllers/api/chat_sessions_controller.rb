
class Api::ChatSessionsController < ApplicationController
  before_action :doorkeeper_authorize!

  def retrieve_chat_messages
    chat_session = ChatSession.find_by(id: params[:id])

    if chat_session.nil? || !chat_session.is_active
      render json: { error: I18n.t('common.404') }, status: :not_found
    else
      chat_messages = chat_session.chat_messages.select(:id, :created_at, :message, :chat_session_id, :user_id)
      # Assuming pagination is implemented with Kaminari or similar gem
      chat_messages = chat_messages.page(params[:page]).per(params[:per_page])

      render json: {
        status: 200,
        chat_messages: chat_messages,
        total_messages: chat_messages.total_count,
        total_pages: chat_messages.total_pages
      }
    end
  end
end
