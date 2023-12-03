class Api::ChatChannelsController < Api::BaseController
  include AuthenticationConcern
  before_action :doorkeeper_authorize!, only: [:create, :validate, :reject_chat_request]
  before_action :authenticate_user!, only: [:create, :validate, :reject_chat_request]
  def create
    # existing create action code...
  end
  def validate
    bid_item_id = validate_params[:bid_item_id]
    bid_item = BidItem.find_by(id: bid_item_id)
    unless bid_item
      render json: { error: "BidItem not found." }, status: :not_found
      return
    end
    if bid_item.is_paid
      render json: { error: "Cannot create chat channel for a paid item." }, status: :unprocessable_entity
      return
    end
    render json: { status: 200, validation: { bid_item_id: bid_item_id, is_valid: true } }, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end
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
  def create_params
    params.require(:chat_channel).permit(:user_id, :bid_item_id)
  end
  def validate_params
    params.require(:chat_channel).permit(:bid_item_id)
  end
  # existing private methods...
end
