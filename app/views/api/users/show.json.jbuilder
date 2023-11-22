if @message.present?

  json.message @message

else

  json.user do
    json.id @user.id

    json.created_at @user.created_at

    json.updated_at @user.updated_at

    json.email @user.email

    json.products @user.products do |product|
      json.created_at product.created_at

      json.updated_at product.updated_at

      json.name product.name

      json.base_price product.base_price

      json.description product.description

      json.image product.image

      json.id product.id

      json.user_id product.user_id
    end

    json.bid_items @user.bid_items do |bid_item|
      json.id bid_item.id

      json.created_at bid_item.created_at

      json.updated_at bid_item.updated_at

      json.user_id bid_item.user_id
    end

    json.bids @user.bids do |bid|
      json.id bid.id

      json.created_at bid.created_at

      json.updated_at bid.updated_at

      json.price bid.price

      json.item_id bid.item_id

      json.user_id bid.user_id
    end

    wallet = @user.wallet
    if wallet.present?
      json.wallet do
        json.id wallet.id

        json.created_at wallet.created_at

        json.updated_at wallet.updated_at

        json.balance wallet.balance

        json.user_id wallet.user_id
      end
    end

    json.deposits @user.deposits do |deposit|
      json.id deposit.id

      json.created_at deposit.created_at

      json.updated_at deposit.updated_at

      json.value deposit.value

      json.user_id deposit.user_id
    end
  end

end
