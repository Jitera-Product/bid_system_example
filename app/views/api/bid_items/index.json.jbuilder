if @message.present?

  json.message @message

else

  json.total_pages @total_pages

  json.bid_items @bid_items do |bid_item|
    json.id bid_item.id

    json.created_at bid_item.created_at

    json.updated_at bid_item.updated_at

    json.base_price bid_item.base_price

    json.status bid_item.status

    json.user_id bid_item.user_id

    product = bid_item.product
    if product.present?
      json.product do
        json.created_at product.created_at

        json.updated_at product.updated_at

        json.name product.name

        json.base_price product.base_price

        json.description product.description

        json.image product.image

        json.id product.id

        json.user_id product.user_id
      end
    end

    json.product_id bid_item.product_id

    json.name bid_item.name

    json.expiration_time bid_item.expiration_time

    json.item_bids bid_item.item_bids do |item_bid|
      json.id item_bid.id

      json.created_at item_bid.created_at

      json.updated_at item_bid.updated_at

      json.price item_bid.price

      json.item_id item_bid.item_id
    end

    json.listing_bid_items bid_item.listing_bid_items do |listing_bid_item|
      json.id listing_bid_item.id

      json.created_at listing_bid_item.created_at

      json.updated_at listing_bid_item.updated_at

      json.listing_id listing_bid_item.listing_id

      json.bid_item_id listing_bid_item.bid_item_id
    end
  end

end
