if @message.present?
  json.message @message
else
  json.product_category do
    json.set! I18n.t('activerecord.attributes.product_category.created_at'), @product_category.created_at
    json.set! I18n.t('activerecord.attributes.product_category.updated_at'), @product_category.updated_at
    json.set! I18n.t('activerecord.attributes.product_category.id'), @product_category.id

    category = @product_category.category
    if category.present?
      json.category do
        json.set! I18n.t('activerecord.attributes.category.id'), category.id
        json.set! I18n.t('activerecord.attributes.category.created_at'), category.created_at
        json.set! I18n.t('activerecord.attributes.category.updated_at'), category.updated_at
        json.set! I18n.t('activerecord.attributes.category.name'), category.name
        json.set! I18n.t('activerecord.attributes.category.created_id'), category.created_id
      end
    end

    json.set! I18n.t('activerecord.attributes.product_category.category_id'), @product_category.category_id

    product = @product_category.product
    if product.present?
      json.product do
        json.set! I18n.t('activerecord.attributes.product.created_at'), product.created_at
        json.set! I18n.t('activerecord.attributes.product.updated_at'), product.updated_at
        json.set! I18n.t('activerecord.attributes.product.name'), product.name
        json.set! I18n.t('activerecord.attributes.product.price'), product.price
        json.set! I18n.t('activerecord.attributes.product.description'), product.description
        json.set! I18n.t('activerecord.attributes.product.image'), product.image
        json.set! I18n.t('activerecord.attributes.product.stock'), product.stock
        json.set! I18n.t('activerecord.attributes.product.id'), product.id
        json.set! I18n.t('activerecord.attributes.product.user_id'), product.user_id
        json.set! I18n.t('activerecord.attributes.product.aproved_id'), product.aproved_id
      end
    end

    json.set! I18n.t('activerecord.attributes.product_category.product_id'), @product_category.product_id
  end
end