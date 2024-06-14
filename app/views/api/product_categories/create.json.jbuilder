if @error_object.present?
  json.error_object @error_object
else
  json.product_category do
    json.extract! @product_category, :id, :category_id, :product_id
    json.created_at @product_category.created_at
    json.updated_at @product_category.updated_at

    json.category do
      json.extract! @product_category.category, :id, :created_at, :updated_at, :name, :created_id
    end

    json.product do
      json.extract! @product_category.product, :created_at, :updated_at, :name, :price, :description, :image, :stock, :id, :user_id, :aproved_id
    end
  end
end