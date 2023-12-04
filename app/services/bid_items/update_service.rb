class BidItems::UpdateService
  def execute(id, name, description, start_price, current_price, status)
    bid_item = BidItem.find_by(id: id)
    return { status: 'error', message: 'Bid item not found' } unless bid_item
    begin
      bid_item.update!(name: name, description: description, start_price: start_price, current_price: current_price, status: status)
      { status: 'success', message: "Bid item's details have been updated.", bid_item: bid_item }
    rescue StandardError => e
      { status: 'error', message: e.message }
    end
  end
end
