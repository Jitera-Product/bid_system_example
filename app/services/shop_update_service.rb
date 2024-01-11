# rubocop:disable Style/ClassAndModuleChildren
class ShopUpdateService
  def update_shop(shop_id, name, address, admin_id)
    admin = Admin.find(admin_id)
    raise 'Unauthorized admin' unless admin&.can_update_shop?

    shop = Shop.find_by(id: shop_id)
    raise 'Shop not found' unless shop
    raise 'Name and address cannot be blank' if name.blank? || address.blank?

    Shop.transaction do
      shop.update!(name: name, address: address)
      ShopUpdateAuditJob.perform_later(shop_id, admin_id)
    end

    { update_status: 'success' }
  rescue ActiveRecord::RecordNotFound => e
    { update_status: 'failure', error: e.message }
  rescue StandardError => e
    { update_status: 'failure', error: e.message }
  end
end
# rubocop:enable Style/ClassAndModuleChildren
