# /app/services/chat_channel_service/create.rb
module ChatChannelService
  class Create < BaseService
    def initialize(bid_item_id, user_id)
      @bid_item_id = bid_item_id
      @user_id = user_id
    end
    def call
      validate_params
      chat_channel = ChatChannel.create(bid_item_id: @bid_item_id, user_id: @user_id, is_closed: false)
      { status: 200, message: I18n.t('chat_channel.success'), chat_channel_id: chat_channel.id }
    rescue => e
      { status: 400, message: e.message }
    end
    private
    def validate_params
      raise I18n.t('user.not_logged_in') unless User.find_by_id(@user_id)
      bid_item = BidItem.find_by_id(@bid_item_id)
      raise I18n.t('bid_item.not_found') unless bid_item
      raise I18n.t('bid_item.already_paid') if bid_item.is_paid
    end
  end
end
