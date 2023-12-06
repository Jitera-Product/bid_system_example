class Api::ChatMessagesController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create]
  before_action :set_chat_channel, only: %i[index create]

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

  def create
    if @chat_channel.nil?
      render json: { error: 'Chat channel not found' }, status: :not_found
      return
    end

    message = params[:message]
    if message.length > 256
      render json: { error: 'Message exceeds 256 characters limit.' }, status: :unprocessable_entity
      return
    end

    if @chat_channel.chat_messages.count >= 500
      render json: { error: 'Maximum messages per channel is 500.' }, status: :unprocessable_entity
      return
    end

    chat_message = @chat_channel.chat_messages.build(message: message, user_id: current_resource_owner.id)

    if chat_message.save
      render json: { status: 201, chat_message: ChatMessageSerializer.new(chat_message).as_json }, status: :created
    else
      render json: { errors: chat_message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_chat_channel
    @chat_channel = ChatChannel.find_by(id: params[:channel_id])
  end

  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end

class ChatMessageSerializer
  def initialize(message)
    @message = message
  end

  def as_json
    {
      id: @message.id,
      channel_id: @message.chat_channel_id,
      user_id: @message.user_id,
      message: @message.message,
      created_at: @message.created_at
    }
  end
end
