module BidItems
  class FetchService
    def self.call(id)
      bid_item = BidItem.find_by(id: id)
      if bid_item
        return {
          id: bid_item.id,
          name: bid_item.name,
          description: bid_item.description,
          start_price: bid_item.start_price,
          current_price: bid_item.current_price,
          status: bid_item.status
        }
      else
        raise "Bid item with id #{id} not found"
      end
    end
  end
end
