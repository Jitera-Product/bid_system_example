class ShopUpdateService
  # Existing code (if any) goes here

  # Add the new method update_shop below
  def update_shop(shop_id, name, address)
    raise ArgumentError, 'Name cannot be blank' if name.blank?
    raise ArgumentError, 'Address cannot be blank' if address.blank?

    shop = Shop.find_by(id: shop_id)
    raise Exceptions::ShopNotFound unless shop

    ShopValidator.new.validate_name(name)
    ShopValidator.new.validate_address(address)

    shop.update!(name: name, address: address)

    ShopUpdateAuditJob.perform_later(shop_id: shop.id, action: 'update', changes: shop.previous_changes)

    ShopSerializer.new(shop).serializable_hash
  end

  # Keep the rest of the existing code below
  # ...
end
