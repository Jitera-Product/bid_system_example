# /app/services/chat_channel_service/create.rb
module ChatChannelService
  class Create
    def initialize(bid_item_id, user_id)
      @bid_item_id = bid_item_id
      @user_id = user_id
    end
    def execute
      validate_params
      chat_channel = ChatChannel.create(bid_item_id: @bid_item_id, user_id: @user_id)
      { status: 200, chat_channel: chat_channel }
    end
    private
    def validate_params
      raise 'Wrong format' unless number?(@bid_item_id) && number?(@user_id)
      bid_item = BidItem.find_by(id: @bid_item_id)
      raise 'This bid item is not found' unless bid_item
      user = User.find_by(id: @user_id)
      raise 'This user is not found' unless user
      raise 'This bid item is already paid' if bid_item.is_paid
    end
    def number?(obj)
      obj.to_s == obj.to_i.to_s
    end
  end
end
