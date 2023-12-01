module Api
  class ChatChannelsController < BaseController
    before_action :authenticate_user!
    def close_chat_channel
      chat_channel_id = params[:id]
      chat_channel = ChatChannel.find_by(id: chat_channel_id)
      if chat_channel.nil?
        render json: { message: 'Chat channel not found' }, status: :not_found
        return
      end
      if chat_channel.is_closed
        render json: { message: 'Chat channel is already closed' }, status: :unprocessable_entity
        return
      end
      begin
        chat_channel.update!(is_closed: true)
        render json: { message: 'Chat channel closed successfully' }, status: :ok
      rescue => e
        render json: { message: e.message }, status: :internal_server_error
      end
    end
    def send_message
      chat_channel_id = params[:chat_channel_id]
      content = params[:content]
      chat_channel = ChatChannel.find_by(id: chat_channel_id)
      if chat_channel.nil?
        render json: { message: 'Chat channel not found' }, status: :not_found
        return
      end
      if chat_channel.is_closed
        render json: { message: 'Chat channel is closed' }, status: :unprocessable_entity
        return
      end
      if chat_channel.messages.count >= 200
        render json: { message: 'Chat channel has reached maximum message limit' }, status: :unprocessable_entity
        return
      end
      if content.length > 200
        render json: { message: 'Message content exceeds character limit' }, status: :unprocessable_entity
        return
      end
      begin
        message = Message.create!(chat_channel_id: chat_channel_id, content: content, created_at: Time.now)
        render json: { message_id: message.id }, status: :ok
      rescue => e
        render json: { message: e.message }, status: :internal_server_error
      end
    end
  end
end
