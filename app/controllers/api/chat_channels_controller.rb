# PATH: /app/controllers/api/chat_channels_controller.rb
class Api::ChatChannelsController < Api::BaseController
  include AuthenticationConcern
  include ErrorHandling
  include ExceptionHandler

  before_action :doorkeeper_authorize!
  before_action :set_chat_channel, only: [:close] # Ensure the chat channel is set for the close action
  before_action :validate_chat_channel_ownership, only: [:close] # Ensure the user owns the chat channel

  # POST /api/chat_channels/check_status
  def check_status
    # ... existing code ...
  end

  def create
    # ... existing code ...
  end

  # PUT /api/chat_channels/:id/close
  def close
    if @chat_channel.nil?
      render json: { error: 'Chat channel not found' }, status: :not_found
      return
    end

    unless @chat_channel.is_active
      render json: { error: 'Chat channel is already closed' }, status: :bad_request
      return
    end

    if ChatChannelService::Index.close_channel(@chat_channel)
      render json: { status: 200, chat_channel: { id: @chat_channel.id, is_active: false } }, status: :ok
    else
      render json: { error: 'Unable to close the chat channel' }, status: :unprocessable_entity
    end
  rescue StandardError => e
    handle_exception(e)
  end

  private

  def set_chat_channel
    @chat_channel = ChatChannel.find_by(id: params[:id])
  end

  def validate_chat_channel_ownership
    unless @chat_channel&.bid_item&.user_id == current_resource_owner.id
      render json: { error: 'User is not the owner of the associated BidItem' }, status: :forbidden
    end
  end

  def validate_user_id(user_id)
    # ... existing code ...
  end

  def validate_and_retrieve_bid_item(bid_item_id)
    # ... existing code ...
  end

  # Other private methods from the existing code...
end
