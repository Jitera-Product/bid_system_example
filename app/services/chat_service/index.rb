# /app/services/chat_service/index.rb
# rubocop:disable Style/ClassAndModuleChildren
class ChatService::Index
  # ... [existing code here, if any]

  def prevent_chat_on_paid_items(bid_item_id)
    bid_item = BidItem.find_by(id: bid_item_id)
    raise CustomError.new('Chat cannot be initiated for paid items') if bid_item&.is_paid
  end

  # ... [rest of the existing code here, if any]

  # Example of where to call the new method within the chat initiation process
  def initiate_chat(bid_item_id, user_id)
    # Call the new method to prevent chat on paid items
    prevent_chat_on_paid_items(bid_item_id)

    # ... [rest of the chat initiation code here]
  end
end
# rubocop:enable Style/ClassAndModuleChildren
