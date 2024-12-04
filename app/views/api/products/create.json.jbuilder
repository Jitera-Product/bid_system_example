if @error_object.present?
  json.error_object @error_object
else
  json.product do
    json.created_at @product.created_at.iso8601
    json.updated_at @product.updated_at.iso8601
    json.id @product.id
    json.name @product.name
    json.price @product.price
    json.description @product.description
    json.image url_for(@product.image) if @product.image.attached?
    json.user_id @product.user_id
    json.stock @product.stock
    json.approved_id @product.approved_id

    json.bid_items @product.bid_items, partial: 'api/bid_items/bid_item', as: :bid_item
    json.product_categories @product.product_categories, partial: 'api/product_categories/product_category', as: :product_category

    if @product.approved.present?
      json.approved do
        json.extract! @product.approved, :id, :name
        json.created_at @product.approved.created_at.iso8601
        json.updated_at @product.approved.updated_at.iso8601
      end
    end
  end
end