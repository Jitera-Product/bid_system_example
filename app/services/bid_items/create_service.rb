module BidItems
  class CreateService
    def initialize(params)
      @params = params
    end
    def execute
      validator = BidItemValidator.new(@params)
      return { message: 'Invalid input data', errors: validator.errors.full_messages } unless validator.valid?
      bid_item = BidItem.new(@params)
      if bid_item.save
        return {
          message: 'Bid item created successfully',
          bid_item: {
            id: bid_item.id,
            name: bid_item.name,
            description: bid_item.description,
            start_price: bid_item.start_price,
            current_price: bid_item.current_price,
            status: bid_item.status
          }
        }
      else
        return { message: 'Failed to create bid item', errors: bid_item.errors.full_messages }
      end
    end
  end
end
