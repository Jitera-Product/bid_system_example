if @error_object.present?

  json.error_object @error_object

else

  json.listing_bid_item do
    json.id @listing_bid_item.id

    json.created_at @listing_bid_item.created_at

    json.updated_at @listing_bid_item.updated_at

    listing = @listing_bid_item.listing
    if listing.present?
      json.listing do
        json.id listing.id

        json.created_at listing.created_at

        json.updated_at listing.updated_at

        json.description listing.description
      end
    end

    json.listing_id @listing_bid_item.listing_id

    bid_item = @listing_bid_item.bid_item
    if bid_item.present?
      json.bid_item do
        json.product_id bid_item.product_id

        json.base_price bid_item.base_price

        json.expiration_time bid_item.expiration_time

        json.status bid_item.status

        json.id bid_item.id

        json.created_at bid_item.created_at

        json.updated_at bid_item.updated_at

        json.user_id bid_item.user_id

        json.name bid_item.name
      end
    end

    json.bid_item_id @listing_bid_item.bid_item_id
  end

end
