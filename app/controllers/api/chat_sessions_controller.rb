# typed: ignore
module Api
  class ChatSessionsController < BaseController
    before_action :doorkeeper_authorize!

    def send_message
      chat_session = ChatSession.find(params[:chat_session_id])
      return render json: { message: I18n.t('common.404') }, status: :not_found unless chat_session
      return render json: { message: I18n.t('common.errors.chat_session_not_active') }, status: :unprocessable_entity unless chat_session.is_active

      user = User.find(params[:user_id])
      return render json: { message: I18n.t('common.404') }, status: :not_found unless user

      if params[:content].blank? || params[:content].length > 512
        return render json: { message: I18n.t('common.errors.content_length') }, status: :unprocessable_entity
      end

      message_count = Message.where(chat_session_id: chat_session.id).count
      if message_count > 30
        return render json: { message: I18n.t('common.errors.message_limit_reached') }, status: :unprocessable_entity
      end

      message = chat_session.messages.create!(user_id: user.id, content: params[:content])
      chat_session.touch

      render json: { status: 201, message: message.as_json(only: [:id, :chat_session_id, :user_id, :content, :created_at]) }, status: :created
    rescue ActiveRecord::RecordNotFound => e
      render json: error_response(nil, e), status: :not_found
    rescue ActiveRecord::RecordInvalid => e
      render json: error_response(nil, e), status: :unprocessable_entity
    end
  end
end
