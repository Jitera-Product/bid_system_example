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

    if @chat_channel.user_id != current_user.id
      render json: { error: 'Unauthorized access to chat channel' }, status: :unauthorized
      return
    end

    if @chat_channel.chat_messages.count >= 500
      render json: { error: 'Maximum messages per channel is 500.' }, status: :unprocessable_entity
      return
    end

    message = params[:message]
    message_validator = MessageValidator.new(message)
    unless message_validator.valid?
      render json: { errors: message_validator.errors.full_messages }, status: :unprocessable_entity
      return
    end

    chat_message = @chat_channel.chat_messages.build(message: message, user_id: current_user.id)

    if chat_message.save
      @chat_channel.touch
      render json: { status: 201, chat_message: ChatMessageSerializer.new(chat_message).as_json }, status: :created
    else
      render json: { errors: chat_message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_chat_channel
    @chat_channel = ChatChannel.find_by(id: params[:channel_id])
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
