class Api::ChatMessagesController < Api::BaseController
  include AuthenticationConcern
  before_action :doorkeeper_authorize!, only: %i[index create]
  before_action :authenticate_user!, only: %i[create]
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
    chat_channel_id = @chat_channel.id
    user_id = current_user.id

    begin
      chat_message = ChatMessageService.send_chat_message(user_id, chat_channel_id, message)
      render json: { status: 201, chat_message: ChatMessageSerializer.new(chat_message).as_json }, status: :created
    rescue ChatMessageService::ChatMessageError => e
      render json: { error: e.message }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { error: 'An unexpected error occurred' }, status: :internal_server_error
    end
  end

  private

  def set_chat_channel
    @chat_channel = ChatChannel.find_by(id: params[:chat_channel_id])
  end

  def authenticate_user!
    render json: { error: 'User must be logged in' }, status: :unauthorized unless current_user
  end

  def current_user
    @current_user ||= User.find_by(id: doorkeeper_token.resource_owner_id) if doorkeeper_token
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

class MessageValidator
  include ActiveModel::Validations

  attr_accessor :message

  validates :message, presence: true, length: { maximum: 256 }

  def initialize(message)
    @message = message
  end
end

class ChatMessageService
  class ChatMessageError < StandardError; end

  def self.send_chat_message(user_id, chat_channel_id, message)
    chat_channel = ChatChannel.find(chat_channel_id)
    raise ChatMessageError, 'Chat channel not found' unless chat_channel

    raise ChatMessageError, 'Unauthorized access to chat channel' unless chat_channel.user_id == user_id

    raise ChatMessageError, 'Maximum messages per channel is 500.' if chat_channel.chat_messages.count >= 500

    message_validator = MessageValidator.new(message)
    raise ChatMessageError, 'Message exceeds 256 characters limit.' if message_validator.errors.any?

    chat_message = chat_channel.chat_messages.build(message: message, user_id: user_id)

    if chat_message.save
      chat_channel.touch
      chat_message
    else
      raise ChatMessageError, chat_message.errors.full_messages.join(', ')
    end
  end
end
