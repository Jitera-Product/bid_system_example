
class Api::BidItemsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update]
  before_action :set_bid_item, only: [:update_status]
  before_action :validate_chat_session_creation, only: [:create_chat_session]

  def index
    # inside service params are checked and whiteisted
    @bid_items = BidItemService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @bid_items.total_pages
  end

  def show
    @bid_item = BidItem.find_by!('bid_items.id = ?', params[:id])
  end

  def create
    @bid_item = BidItem.new(create_params)

    return if @bid_item.save

    @error_object = @bid_item.errors.messages

    render status: :unprocessable_entity
  end

  def disable_chat_session
    bid_item_id = params[:id]
    bid_item = BidItem.find_by!(id: bid_item_id)

    unless bid_item.status_done?
      render json: { error: 'Chat session is already inactive.' }, status: :unprocessable_entity
      return
    end

    chat_sessions = bid_item.chat_sessions.where(is_active: true)
    chat_sessions.each do |chat_session|
      chat_session.update!(is_active: false)
    end

    render json: {
      status: 200,
      message: I18n.t('chat_sessions_disabled_confirmation'),
      chat_sessions: chat_sessions.as_json(only: [:id, :updated_at, :is_active, :bid_item_id])
    }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Chat session not found.' }, status: :not_found
  end

  def close
    bid_item = BidItem.find(params[:id])
    bid_item.close_bid_item
    render json: bid_item, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: I18n.t('common.404') }, status: :not_found
  rescue StandardError => e
    render json: error_response(bid_item, e), status: :unprocessable_entity
  end

  def create_params
    params.require(:bid_items).permit(:user_id, :product_id, :base_price, :status, :name, :expiration_time)
  end

  def update
    @bid_item = BidItem.find_by('bid_items.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @bid_item.blank?

    return if @bid_item.update(update_params)

    @error_object = @bid_item.errors.messages

    render status: :unprocessable_entity
  end

  def update_params
    params.require(:bid_items).permit(:user_id, :product_id, :base_price, :status, :name, :expiration_time)
  end

  def update_status
    bid_item_id = params[:id]
    new_status = params[:status]

    unless BidItem.statuses.keys.include?(new_status)
      render json: { error: I18n.t('controller.bid_item.invalid_status') }, status: :unprocessable_entity
      return
    end

    if @bid_item.update(status: new_status)
      @bid_item.close_bid_item if new_status == 'done'
      render json: {
        status: 200,
        message: I18n.t('controller.bid_item.update.success'),
        bid_item: {
          id: @bid_item.id,
          status: @bid_item.status,
          updated_at: @bid_item.updated_at
        }
      }, status: :ok
    else
      render json: { error: @bid_item.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  def create_chat_session
    bid_item = BidItem.find_by(id: chat_session_params[:bid_item_id])
    unless bid_item
      return render json: { error: I18n.t('bid_item.not_found') }, status: :not_found
    end

    if bid_item.status_done?
      return render json: { error: I18n.t('bid_item.chat_not_initiated_for_completed_items') }, status: :unprocessable_entity
    end

    chat_session = ChatSession.find_or_initialize_by(bid_item_id: bid_item.id, user_id: current_resource_owner.id)
    if chat_session.new_record?
      chat_session.is_active = true
      chat_session.save!
      render json: { status: I18n.t('common.201'), chat_session: chat_session }, status: :created
    else
      render json: { error: I18n.t('bid_item.chat_session_already_exists') }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.record.errors.full_messages.to_sentence }, status: :unprocessable_entity
  end

  private

  def chat_session_params
    params.permit(:bid_item_id)
  end

  def validate_chat_session_creation
    render json: { error: I18n.t('common.401') }, status: :unauthorized unless current_resource_owner
  end

  # Add any additional error handling or private methods below

  def set_bid_item
    @bid_item = BidItem.find_by(id: params[:id])
    unless @bid_item
      render json: { error: I18n.t('bid_item.not_found') }, status: :not_found
    end
  end

end
