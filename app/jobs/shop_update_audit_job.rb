class ShopUpdateAuditJob < ApplicationJob
  queue_as :default

  def perform(shop_id, name, address)
    # Validate and update shop information
    update_result = Shop.update_shop_info(shop_id, name, address)

    # Log the shop update details for audit purposes
    if update_result == 'Shop information updated successfully'
      Rails.logger.info "Shop Update - #{Time.current}: Shop ID: #{shop_id}, Name: #{name}, Address: #{address}"
    else
      Rails.logger.error "Shop Update Failed - #{Time.current}: #{update_result}"
    end
  end
end
