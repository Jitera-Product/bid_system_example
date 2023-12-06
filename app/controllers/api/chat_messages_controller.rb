class Api::ChatMessagesController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index]
  before_action :set_chat_channel, only: %i[index]

  def index
    if @chat_channel
      chat_messages = @chat_channel.chat_messages
      serialized_messages = chat_messages.map do |message|
        ChatMessageSerializer.new(message).as_json
      end
      render json: { messages: serialized_messages }, status: :ok
    else
      render json: { error: 'Chat channel not found' }, status: :not_found
    end
  end

  private

  def set_chat_channel
    @chat_channel = ChatChannel.find_by(id: params[:channel_id])
  end
end

class ChatMessageSerializer
  def initialize(message)
    @message = message
  end

  def as_json
    {
      message_id: @message.id,
      user_id: @message.user_id,
      message: @message.message,
      created_at: @message.created_at
    }
  end
end
