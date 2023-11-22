if @error_object.present?

  json.error_object @error_object

else

  json.bid do
    json.id @bid.id

    json.created_at @bid.created_at

    json.updated_at @bid.updated_at

    json.price @bid.price

    item = @bid.item
    if item.present?
      json.item do
        json.product_id item.product_id

        json.base_price item.base_price

        json.expiration_time item.expiration_time

        json.status item.status

        json.id item.id

        json.created_at item.created_at

        json.updated_at item.updated_at

        json.user_id item.user_id

        json.name item.name
      end
    end

    json.item_id @bid.item_id

    json.user_id @bid.user_id

    json.status @bid.status

    shipping = @bid.shipping
    if shipping.present?
      json.shipping do
        json.post_code shipping.post_code

        json.full_name shipping.full_name

        json.phone_number shipping.phone_number

        json.email shipping.email

        json.bid_id shipping.bid_id

        json.id shipping.id

        json.created_at shipping.created_at

        json.updated_at shipping.updated_at

        json.status shipping.status

        json.shiping_address shipping.shiping_address
      end
    end
  end

end
