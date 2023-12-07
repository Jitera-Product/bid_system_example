class Api::MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat_channel, only: [:create, :index] # Updated to include :index action
  before_action :validate_message_count, only: [:create]
  before_action :validate_sender, only: [:create]
  before_action :validate_content, only: [:create]

  # POST /api/messages
  def create
    begin
      message = Message.create!(
        chat_channel: @chat_channel,
        user_id: current_user.id,
        content: params[:content],
        created_at: Time.current
      )
      render json: { message_id: message.id, created_at: message.created_at }, status: :created
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
        'messages.id',
        'messages.chat_channel_id',
        'users.id as sender_id',
        'messages.content',
        'messages.created_at as sent_at'
      )

      serialized_messages = messages.map do |message|
        {
          id: message.id,
          chat_channel_id: message.chat_channel_id,
          sender_id: message.sender_id,
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
      render json: { error: 'Message limit reached for this chat channel' }, status: :forbidden
      throw(:abort)
    end
  end

  def validate_content
    content = params[:content]
    if content.blank? || content.length > 256
      render json: { error: 'Content is invalid' }, status: :unprocessable_entity
      throw(:abort)
    end
  end

  def handle_exception(exception)
    render_exception(exception)
  end
end
