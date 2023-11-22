if @message.present?

  json.message @message

else

  json.total_pages @total_pages

  json.listings @listings do |listing|
    json.description listing.description

    json.id listing.id

    json.created_at listing.created_at

    json.updated_at listing.updated_at

    json.listing_bid_items listing.listing_bid_items do |listing_bid_item|
      json.id listing_bid_item.id

      json.created_at listing_bid_item.created_at

      json.updated_at listing_bid_item.updated_at

      json.listing_id listing_bid_item.listing_id
    end
  end

end
