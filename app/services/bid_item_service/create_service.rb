module BidItemService
  class CreateService
    def execute(name, description, start_price, current_price, status)
      bid_item = BidItem.new(name: name, description: description, start_price: start_price, current_price: current_price, status: status)
      if bid_item.save
        return { message: 'Bid item created successfully', bid_item: bid_item }
      else
        return { message: 'Failed to create bid item', errors: bid_item.errors.full_messages }
      end
    end
  end
end
