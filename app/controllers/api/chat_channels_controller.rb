class Api::ChatChannelsController < Api::BaseController
  include AuthenticationConcern
  before_action :doorkeeper_authorize!, only: [:create, :reject_chat_request]
  before_action :authenticate_user!, only: [:create, :reject_chat_request]
  # existing create action...
  def reject_chat_request
    chat_channel_id = params[:id]
    chat_channel = ChatChannel.find_by(id: chat_channel_id)
    if chat_channel.nil? || !chat_channel.is_active
      render json: { error: 'Chat channel not found or already inactive' }, status: :unprocessable_entity
      return
    end
    bid_item = chat_channel.bid_item
    unless bid_item.owner_id == current_user.id
      render json: { error: 'User is not the owner of the BidItem.' }, status: :forbidden
      return
    end
    if ChatChannelService.close_channel(chat_channel_id, current_user.id)
      render json: {
        status: 200,
        chat_channel: {
          id: chat_channel.id,
          bid_item_id: bid_item.id,
          user_id: chat_channel.user_id,
          owner_id: bid_item.owner_id,
          is_active: chat_channel.reload.is_active
        }
      }, status: :ok
    else
      render json: { error: 'Unable to reject chat request' }, status: :unprocessable_entity
    end
  end
  private
  # existing private methods...
end
