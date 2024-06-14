json.total_pages @total_pages

json.product_categories @product_categories do |product_category|
  json.created_at product_category.created_at.iso8601
  json.updated_at product_category.updated_at.iso8601
  json.id product_category.id
  json.category_id product_category.category_id
  json.product_id product_category.product_id

  json.category do
    json.id product_category.category.id
    json.created_at product_category.category.created_at.iso8601
    json.updated_at product_category.category.updated_at.iso8601
    json.name product_category.category.name
    json.created_id product_category.category.admin_id
  end

  json.product do
    json.created_at product_category.product.created_at.iso8601
    json.updated_at product_category.product.updated_at.iso8601
    json.name product_category.product.name
    json.price product_category.product.price
    json.description product_category.product.description
    json.image product_category.product.image.url
    json.stock product_category.product.stock
    json.id product_category.product.id
    json.user_id product_category.product.user_id
    json.approved_id product_category.product.admin_id
  end
end