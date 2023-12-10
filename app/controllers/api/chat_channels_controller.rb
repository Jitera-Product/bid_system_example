class Api::ChatChannelsController < Api::BaseController
  before_action :doorkeeper_authorize!
  before_action :validate_user, only: [:create]

  def create
    bid_item = BidItem.find_by(id: chat_channel_params[:bid_item_id])

    unless bid_item
      render json: { error: 'Bid item not found.' }, status: :not_found and return
    end

    unless bid_item.chat_enabled
      render json: { error: 'Cannot create a channel for this item.' }, status: :bad_request and return
    end

    if bid_item.status == 'done' # Assuming 'done' is a valid status value
      render json: { error: 'Bid item already done.' }, status: :bad_request and return
    end

    authorize bid_item, :create_chat_channel?

    chat_channel = bid_item.chat_channels.create!(
      created_at: Time.current, # Assuming Time.current is the method to get the current timestamp
      updated_at: Time.current
    )

    render json: { status: 201, channel: chat_channel.as_json(only: [:id, :bid_item_id, :created_at]) }, status: :created
  rescue Pundit::NotAuthorizedError
    render json: { error: 'You are not authorized to perform this action.' }, status: :forbidden
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def chat_channel_params
    params.require(:chat_channel).permit(:bid_item_id)
  end

  def validate_user
    unless current_user.id == params[:user_id].to_i
      render json: { error: 'Invalid user.' }, status: :unauthorized
    end
  end
end
