if @error_object.present?

  json.error_object @error_object

else

  json.admin do
    json.id @admin.id

    json.created_at @admin.created_at

    json.updated_at @admin.updated_at

    json.name @admin.name

    json.aproved_products @admin.aproved_products do |aproved_product|
      json.created_at aproved_product.created_at

      json.updated_at aproved_product.updated_at

      json.name aproved_product.name

      json.price aproved_product.price

      json.description aproved_product.description

      json.image aproved_product.image

      json.stock aproved_product.stock

      json.id aproved_product.id

      json.user_id aproved_product.user_id

      json.aproved_id aproved_product.aproved_id
    end

    json.email @admin.email

    json.aprroved_withdrawals @admin.aprroved_withdrawals do |aprroved_withdrawal|
      json.value aprroved_withdrawal.value

      json.status aprroved_withdrawal.status

      json.id aprroved_withdrawal.id

      json.created_at aprroved_withdrawal.created_at

      json.updated_at aprroved_withdrawal.updated_at

      json.aprroved_id aprroved_withdrawal.aprroved_id
    end

    json.created_categories @admin.created_categories do |created_category|
      json.id created_category.id

      json.created_at created_category.created_at

      json.updated_at created_category.updated_at

      json.name created_category.name

      json.created_id created_category.created_id
    end
  end

end
