if @message.present?

  json.message @message

else

  json.total_pages @total_pages

  json.categories @categories do |category|
    json.id category.id

    json.created_at category.created_at

    json.updated_at category.updated_at

    json.name category.name

    created = category.created
    if created.present?
      json.created do
        json.id created.id

        json.created_at created.created_at

        json.updated_at created.updated_at

        json.name created.name

        json.email created.email
      end
    end

    json.created_id category.created_id

    json.product_categories category.product_categories do |product_category|
      json.created_at product_category.created_at

      json.updated_at product_category.updated_at

      json.category_id product_category.category_id

      json.id product_category.id
    end

    json.disabled category.disabled
  end

end
