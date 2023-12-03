# PATH: /app/controllers/api/chat_channels_controller.rb
class Api::ChatChannelsController < Api::BaseController
  include AuthenticationConcern
  include ErrorHandling

  before_action :doorkeeper_authorize!

  def create
    validate_user_id(params[:user_id])
    bid_item = validate_and_retrieve_bid_item(params[:bid_item_id])

    chat_channel = ChatChannelService.create_chat_channel(
      user_id: params[:user_id],
      owner_id: bid_item.user_id,
      bid_item_id: params[:bid_item_id],
      is_active: true # Ensuring that the is_active attribute is set to true as per requirement
    )

    # Changed the response to return only the chat_channel_id as per requirement
    render json: { chat_channel_id: chat_channel.id }, status: :created
  rescue StandardError => e
    handle_error(e)
  end

  private

  def validate_user_id(user_id)
    unless current_resource_owner && current_resource_owner.id == user_id.to_i
      raise AuthenticationError, 'User must be logged in and valid to create a chat channel.'
    end
  end

  def validate_and_retrieve_bid_item(bid_item_id)
    bid_item = BidItem.find_by(id: bid_item_id)
    raise ActiveRecord::RecordNotFound, 'Bid item not found.' unless bid_item
    raise StandardError, 'Bid item is already paid for.' if bid_item.is_paid

    bid_item
  end
end
