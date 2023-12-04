class BidItems::UpdateService
  def self.execute(id, name, description, start_price, current_price, status)
    raise 'Wrong format' unless id.is_a?(Numeric)
    bid_item = BidItem.find_by(id: id)
    raise 'This bid item is not found' unless bid_item
    validator = BidItemValidator.new(name: name, description: description, start_price: start_price, current_price: current_price, status: status)
    raise validator.errors.full_messages.to_sentence unless validator.valid?
    bid_item.update!(name: name, description: description, start_price: start_price, current_price: current_price, status: status)
    bid_item
  rescue StandardError => e
    raise e.message
  end
end
