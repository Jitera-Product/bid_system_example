class Api::ChatChannelsController < Api::BaseController
  before_action :doorkeeper_authorize!
  before_action :set_chat_channel, only: [:fetch_chat_messages, :create]

  # Existing code here...

  def create
    user = current_resource_owner
    return render status: :unauthorized unless user.id == params[:user_id].to_i

    bid_item = BidItem.find_by(id: params[:bid_item_id])
    return render status: :not_found, json: { error: 'Bid item not found' } unless bid_item

    unless bid_item.chat_enabled
      return render status: :bad_request, json: { error: 'Cannot create a channel for this item' }
    end

    if bid_item.status == 'done'
      return render status: :bad_request, json: { error: 'Bid item already done' }
    end

    # Check the maximum number of messages per channel
    return if check_max_messages_per_channel

    chat_channel = ChatChannel.create!(user_id: user.id, bid_item_id: bid_item.id)

    render json: { channel_id: chat_channel.id, created_at: chat_channel.created_at }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render status: :unprocessable_entity, json: { errors: e.record.errors.full_messages }
  end

  # Updated fetch_chat_messages action
  def fetch_chat_messages
    if @chat_channel
      messages = @chat_channel.chat_messages.select(:id, :content, :user_id, :created_at, :updated_at)
      render json: { chat_messages: messages }, status: :ok
    else
      render status: :not_found, json: { error: 'Chat channel not found.' }
    end
  end

  private

  def set_chat_channel
    @chat_channel = ChatChannel.find_by(id: params[:channel_id])
  end

  # Updated private method to check the maximum number of messages per channel
  def check_max_messages_per_channel
    message_count = @chat_channel.chat_messages.count
    if message_count >= 500
      render status: :bad_request, json: { error: 'Maximum number of messages reached for this channel' }
      return true
    end
    false
  end

  # Rest of the existing code...
end
