if @error_object.present?

  json.error_object @error_object

else

  json.shipping do
    json.shiping_address @shipping.shiping_address

    json.id @shipping.id

    json.created_at @shipping.created_at

    json.updated_at @shipping.updated_at

    json.full_name @shipping.full_name

    json.status @shipping.status

    json.post_code @shipping.post_code

    json.phone_number @shipping.phone_number

    json.email @shipping.email

    bid = @shipping.bid
    if bid.present?
      json.bid do
        json.id bid.id

        json.created_at bid.created_at

        json.updated_at bid.updated_at

        json.status bid.status

        json.price bid.price

        json.item_id bid.item_id

        json.user_id bid.user_id
      end
    end

    json.bid_id @shipping.bid_id
  end

end
