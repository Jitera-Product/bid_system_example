class Api::MessagesController < Api::BaseController
  before_action :doorkeeper_authorize!, only: [:create]

  # POST /api/messages
  def create
    chat_channel = ChatChannel.find_by(id: params[:chat_channel_id])
    return render json: { error: 'Chat channel not found' }, status: :not_found unless chat_channel

    if chat_channel.messages.count >= 500
      # Handle the situation, e.g., inform the user or archive messages
      # This is a placeholder for actual implementation
      return render json: { error: 'Message limit reached for this chat channel' }, status: :unprocessable_entity
    end

    content = params[:content]
    return render json: { error: 'Content exceeds 256 characters' }, status: :unprocessable_entity if content.length > 256

    message = chat_channel.messages.build(user_id: current_resource_owner.id, content: content)
    if message.save
      MessageBroadcastJob.perform_later(message)
      render json: {
        message_id: message.id,
        chat_channel_id: message.chat_channel_id,
        user_id: message.user_id,
        content: message.content,
        created_at: message.created_at
      }, status: :created
    else
      render json: { errors: message.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
