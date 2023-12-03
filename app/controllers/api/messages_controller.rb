# PATH: /app/controllers/api/messages_controller.rb
class Api::MessagesController < ApplicationController
  include AuthenticationConcern

  def create
    authenticate_request!
    sender_id = current_user.id
    chat_channel_id = params[:chat_channel_id]
    content = params[:content]

    begin
      chat_channel = ChatChannel.find(chat_channel_id)

      if chat_channel.is_active
        if Message.where(chat_channel_id: chat_channel_id).count < 200
          if content.length <= 200
            message = Message.create!(
              chat_channel_id: chat_channel_id,
              user_id: sender_id,
              content: content,
              created_at: Time.current # This line is not necessary as Rails automatically sets created_at
            )
            render json: { message_id: message.id, created_at: message.created_at }, status: :created
          else
            render json: { error: 'Content length exceeds 200 characters' }, status: :unprocessable_entity
          end
        else
          render json: { error: 'Message limit reached for this chat channel' }, status: :unprocessable_entity
        end
      else
        render json: { error: 'Chat channel is not active' }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Chat channel not found' }, status: :not_found
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  # Other controller methods...
end
