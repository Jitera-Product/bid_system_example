module Api
  class ChatChannelsController < BaseController
    before_action :authenticate_user!
    def create
      user_id = params[:user_id]
      bid_item_id = params[:bid_item_id]
      # Validate parameters
      if user_id.blank? || bid_item_id.blank?
        render json: { message: 'User ID and Bid Item ID are required' }, status: :bad_request
        return
      end
      # Validate user_id and bid_item_id format
      unless user_id.is_a?(Integer) && bid_item_id.is_a?(Integer)
        render json: { message: 'Wrong format' }, status: :unprocessable_entity
        return
      end
      # Validate user and bid item existence
      user = User.find_by(id: user_id)
      bid_item = BidItem.find_by(id: bid_item_id)
      if user.nil?
        render json: { message: 'This user is not found' }, status: :not_found
        return
      end
      if bid_item.nil?
        render json: { message: 'This bid item is not found' }, status: :not_found
        return
      end
      # Validate bid item status
      if bid_item.is_paid
        render json: { message: 'This bid item is already paid' }, status: :unprocessable_entity
        return
      end
      # Use ChatChannelService to create a new chat channel
      begin
        chat_channel = ChatChannelService::Create.execute(user_id, bid_item_id)
        render json: { chat_channel: chat_channel }, status: :ok
      rescue => e
        render json: { message: e.message }, status: :internal_server_error
      end
    end
    def close_chat_channel
      chat_channel_id = params[:chat_channel_id]
      chat_channel = ChatChannel.find_by(id: chat_channel_id)
      if chat_channel.nil?
        render json: { message: 'Chat channel not found' }, status: :not_found
        return
      end
      bid_item = BidItem.find_by(id: chat_channel.bid_item_id)
      if bid_item.nil? || bid_item.user_id != current_user.id
        render json: { message: 'You are not authorized to close this chat channel' }, status: :unauthorized
        return
      end
      chat_channel.update(is_closed: true)
      render json: { message: 'Chat channel closed successfully' }, status: :ok
    end
    # ... rest of the code
  end
end
