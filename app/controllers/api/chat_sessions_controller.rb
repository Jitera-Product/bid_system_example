
class Api::ChatSessionsController < ApplicationController
  before_action :doorkeeper_authorize!

  def close
    chat_session = ChatSession.find_by(id: params[:id])

    if chat_session.nil?
      render json: { error: I18n.t('chat_sessions.close.error.not_found') }, status: :not_found
    elsif !chat_session.is_active
      render json: { error: I18n.t('chat_sessions.close.error.not_active') }, status: :unprocessable_entity
    elsif chat_session.bid_item.status_done?
      chat_session.update!(is_active: false, updated_at: Time.current)
      render 'api/chat_sessions/close', locals: { chat_session: chat_session }, status: :ok
    else
      render json: { error: I18n.t('common.422') }, status: :unprocessable_entity
    end
  end

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
