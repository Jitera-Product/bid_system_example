if @message.present?

  json.message @message

else

  json.product do
    json.created_at @product.created_at

    json.updated_at @product.updated_at

    json.id @product.id

    json.name @product.name

    json.price @product.price

    json.description @product.description

    json.image @product.image

    json.user_id @product.user_id

    json.bid_items @product.bid_items do |bid_item|
      json.product_id bid_item.product_id

      json.id bid_item.id

      json.created_at bid_item.created_at

      json.updated_at bid_item.updated_at

      json.user_id bid_item.user_id
    end

    json.stock @product.stock

    aproved = @product.aproved
    if aproved.present?
      json.aproved do
        json.id aproved.id

        json.created_at aproved.created_at

        json.updated_at aproved.updated_at

        json.name aproved.name
      end
    end

    json.aproved_id @product.aproved_id

    json.product_categories @product.product_categories do |product_category|
      json.created_at product_category.created_at

      json.updated_at product_category.updated_at

      json.category_id product_category.category_id

      json.product_id product_category.product_id

      json.id product_category.id
    end
  end

end
