class Api::ChatChannelsController < Api::BaseController
  before_action :doorkeeper_authorize!
  before_action :set_chat_channel, only: [:fetch_chat_messages]

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

    chat_channel = ChatChannel.create!(user_id: user.id, bid_item_id: bid_item.id)

    render json: { channel_id: chat_channel.id, created_at: chat_channel.created_at }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render status: :unprocessable_entity, json: { errors: e.record.errors.full_messages }
  end

  # New fetch_chat_messages action
  def fetch_chat_messages
    if @chat_channel
      messages = ChatChannelService::Index.fetch_messages(@chat_channel.id)
      render json: { status: 200, chat_messages: messages }, status: :ok
    else
      render status: :not_found, json: { error: 'Chat channel not found.' }
    end
  end

  private

  def set_chat_channel
    @chat_channel = ChatChannel.find_by(id: params[:channel_id])
  end

  # Rest of the existing code...
end
