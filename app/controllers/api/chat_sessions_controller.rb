class Api::ChatSessionsController < ApplicationController
  before_action :doorkeeper_authorize!

  def create
    bid_item_id = params[:bid_item_id]
    bid_item_service = BidItemService::Index.new(bid_item_id: bid_item_id)

    if bid_item_service.execute.blank?
      render json: { error: I18n.t('chat_session.create.error.bid_item_not_found') }, status: :not_found
    elsif !bid_item_service.records.first.active?
      render json: { error: I18n.t('chat_session.create.error.bid_item_inactive') }, status: :unprocessable_entity
    else
      chat_session = ChatSession.create!(is_active: true, bid_item_id: bid_item_id, created_at: Time.current, updated_at: Time.current)
      render json: { status: I18n.t('common.201'), chat_session: chat_session }, status: :created
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.record.errors.full_messages.to_sentence }, status: :unprocessable_entity
  end

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
    chat_session_id = params[:chat_session_id].to_i

    if chat_session_id <= 0
      render json: { error: I18n.t('chat_session_id_invalid') }, status: :unprocessable_entity
      return
    end

    chat_session = ChatSession.find_by(id: chat_session_id)

    if chat_session.nil?
      render json: { error: I18n.t('chat_session_not_found') }, status: :not_found
    elsif !chat_session.is_active
      render json: { error: I18n.t('common.404') }, status: :not_found
    elsif !policy(chat_session).retrieve_chat_messages?
      render json: { error: I18n.t('chat_session_unauthorized') }, status: :forbidden
    else
      chat_messages = chat_session.chat_messages.select(:id, :created_at, :message, :chat_session_id, :user_id)
      # Assuming pagination is implemented with Kaminari or similar gem
      chat_messages = chat_messages.page(params[:page]).per(params[:per_page])

      render json: {
        status: 200,
        chat_messages: chat_messages,
        total_messages: chat_messages.total_count,
        total_pages: chat_messages.total_pages
      }, status: :ok
    end
  end

  # Other controller actions...
end
