class Api::ChatChannelsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat_channel, only: [:create]

  def create
    bid_item = BidItem.find(params[:bid_item_id])

    unless bid_item.is_chat_enabled
      return render json: { error: 'Can not create a channel for this item' }, status: :bad_request
    end

    if bid_item.status == 'done'
      return render json: { error: 'Bid item already done' }, status: :bad_request
    end

    chat_channel = ChatChannel.create!(bid_item_id: bid_item.id, created_at: Time.current)

    render json: { chat_channel_id: chat_channel.id }, status: :created
  end

  def send_message
    set_chat_channel # Ensure chat_channel is set

    begin
      validate_message_count
      validate_content(params[:content])
      message = @chat_channel.messages.create!(
        user: current_user,
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
          created_at: message.created_at
        }
      }, status: :created
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
    rescue => e
      handle_exception(e)
    end
  end

  private

  def set_chat_channel
    @chat_channel = ChatChannel.find_by(id: params[:chat_channel_id])
    render json: { error: 'Chat channel not found' }, status: :not_found unless @chat_channel
  end

  def validate_message_count
    if @chat_channel.messages.count >= 500
      render json: { error: 'Maximum messages per channel is 500.' }, status: :forbidden
      throw(:abort)
    end
  end

  def validate_content(content)
    if content.length > 256
      render json: { error: 'Message exceeds 256 characters limit.' }, status: :unprocessable_entity
      throw(:abort)
    end
  end

  def handle_exception(exception)
    # Assuming there's a method in ApplicationController or included module to handle exceptions
    render_exception(exception)
  end

  def authenticate_user!
    # Logic to authenticate user by user_id
    raise Exceptions::AuthenticationError unless current_user && current_user.id == params[:user_id].to_i
  end
end
