if @message.present?

  json.message @message

else

  json.total_pages @total_pages

  json.product_categories @product_categories do |product_category|
    json.created_at product_category.created_at

    json.updated_at product_category.updated_at

    json.id product_category.id

    category = product_category.category
    if category.present?
      json.category do
        json.id category.id

        json.created_at category.created_at

        json.updated_at category.updated_at

        json.name category.name

        json.created_id category.created_id
      end
    end

    json.category_id product_category.category_id

    product = product_category.product
    if product.present?
      json.product do
        json.created_at product.created_at

        json.updated_at product.updated_at

        json.name product.name

        json.price product.price

        json.description product.description

        json.image product.image

        json.stock product.stock

        json.id product.id

        json.user_id product.user_id

        json.aproved_id product.aproved_id
      end
    end

    json.product_id product_category.product_id
  end

end
