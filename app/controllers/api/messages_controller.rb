class Api::MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat_channel, only: [:create, :index] # Note: :fetch_messages action is not present in the existing code, so it's replaced with :index
  before_action :validate_message_count, only: [:create]
  before_action :validate_sender, only: [:create]
  before_action :validate_content, only: [:create]

  # POST /api/chat_channels/:chat_channel_id/messages
  def create
    begin
      message = Message.create!(
        chat_channel: @chat_channel,
        user_id: current_user.id,
        content: params[:content],
        created_at: Time.current
      )
      render json: {
        status: 201,
        message: {
          id: message.id,
          chat_channel_id: @chat_channel.id,
          sender_id: current_user.id,
          content: message.content,
          sent_at: message.created_at
        }
      }, status: :created
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
    rescue => e
      handle_exception(e)
    end
  end

  # GET /api/messages
  def index # Renamed from fetch_messages to index as per RESTful conventions
    if @chat_channel.nil?
      render json: { error: 'Chat channel not found' }, status: :not_found
    else
      messages = @chat_channel.messages.includes(:user).select(
        'messages.id as message_id', # Updated to match the new code's alias
        'users.id as sender_id',
        'users.name as sender_name', # Added to include sender's name in the response
        'messages.content',
        'messages.created_at as sent_at'
      )

      serialized_messages = messages.map do |message|
        {
          message_id: message.message_id,
          sender_id: message.sender_id,
          sender_name: message.sender_name, # Added to include sender's name in the response
          content: message.content,
          sent_at: message.sent_at
        }
      end

      render json: { status: 200, messages: serialized_messages }, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message }, status: :not_found
    rescue => e
      handle_exception(e)
    end
  end

  private

  def validate_sender
    unless current_user.id == params[:sender_id].to_i
      render json: { error: 'Sender ID does not match logged-in user' }, status: :forbidden
      throw(:abort)
    end
  end

  def set_chat_channel
    @chat_channel = ChatChannel.find_by(id: params[:chat_channel_id])
    unless @chat_channel
      render json: { error: 'Chat channel not found' }, status: :not_found
      throw(:abort)
    end
  end

  def validate_message_count
    if @chat_channel.messages.count >= 500
      render json: { error: 'Maximum messages per channel reached.' }, status: :forbidden
      throw(:abort)
    end
  end

  def validate_content
    content = params[:content]
    if content.blank? || content.length > 256
      render json: { error: 'Message exceeds 256 characters.' }, status: :unprocessable_entity
      throw(:abort)
    end
  end

  def handle_exception(exception)
    render_exception(exception)
  end
end
