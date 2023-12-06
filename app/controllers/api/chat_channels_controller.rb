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

    render json: { status: 201, chat_channel: { id: chat_channel.id, created_at: chat_channel.created_at, bid_item_id: bid_item.id, user_id: user.id } }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render status: :unprocessable_entity, json: { errors: e.record.errors.full_messages }
  end

  # Existing fetch_chat_messages action...
  # Existing private methods...
end
