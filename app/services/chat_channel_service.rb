class ChatChannelService
  include ErrorHandling # Assuming ErrorHandling module exists as per guideline

  # ... other methods ...

  # New method to check the chat channel status
  def check_chat_channel_status(chat_channel_id)
    chat_channel = ChatChannel.find_by(id: chat_channel_id)
    if chat_channel
      { chat_channel_id: chat_channel.id, is_active: chat_channel.is_active }
    else
      raise "ChatChannel with id #{chat_channel_id} does not exist."
    end
  end

  def create_chat_channel(user_id, bid_item_id)
    validate_user(user_id)
    bid_item = validate_bid_item(bid_item_id)
    raise StandardError, 'Bid item is already paid for' if bid_item.is_paid

    chat_channel = ChatChannel.new(
      user_id: user_id,
      owner_id: bid_item.user_id, # Assuming bid_item.user_id is the owner_id
      bid_item_id: bid_item_id,
      is_active: true
    )

    if chat_channel.save
      chat_channel.id
    else
      raise StandardError, 'Failed to create chat channel'
    end
  rescue => e
    handle_exception(e) # Assuming handle_exception method exists within ErrorHandling module
  end

  def close_chat_channel(chat_channel_id, owner_id)
    # Ensure owner_id corresponds to a logged-in user (assuming there's a method `logged_in?`)
    raise CustomException.new('User must be logged in') unless logged_in?(owner_id)

    chat_channel = ChatChannel.find_by(id: chat_channel_id)
    raise CustomException.new('Chat channel not found') unless chat_channel

    authorized = ChatChannelPolicy.new(owner_id, chat_channel).validate_owner
    raise CustomException.new('Not authorized to close this chat channel') unless authorized

    chat_channel.update!(is_active: false)
    { chat_channel_id: chat_channel.id, is_active: chat_channel.is_active }
  rescue StandardError => e
    raise CustomException.new(e.message)
  end

  # ... other methods ...

  private

  # Assuming there's a method to check if a user is logged in
  def logged_in?(user_id)
    # Logic to check if the user is logged in
    UserService.logged_in?(user_id) # Assuming UserService has a method to check if user is logged in
  end

  def validate_user(user_id)
    raise StandardError, 'User must be logged in' unless logged_in?(user_id)
  end

  def validate_bid_item(bid_item_id)
    bid_item = BidItemService.find_by_id(bid_item_id)
    raise StandardError, 'Bid item does not exist' unless bid_item
    bid_item
  end
end
