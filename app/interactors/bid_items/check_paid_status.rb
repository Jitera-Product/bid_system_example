# PATH: /app/interactors/bid_items/check_paid_status.rb
module BidItems
  class CheckPaidStatus
    include Interactor
    def call
      bid_item = BidItem.find_by(id: context.bid_item_id)
      if bid_item.nil?
        context.fail!(error: "BidItem not found")
      elsif bid_item.is_paid
        context.fail!(error: "Initiating a chat on a paid item is not allowed")
      end
    end
  end
end
