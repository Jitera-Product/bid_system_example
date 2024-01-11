# frozen_string_literal: true

class ShopUpdateAuditJob < ApplicationJob
  queue_as :default

  def perform(shop_id, admin_id)
    # Logic to log the shop update action
    AuditLog.create(
      shop_id: shop_id,
      admin_id: admin_id,
      action: 'update',
      created_at: Time.current
    )
  end
end
