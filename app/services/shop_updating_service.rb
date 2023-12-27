# /app/services/shop_updating_service.rb

class ShopUpdatingService
  attr_reader :shop_id, :name, :address, :user

  def initialize(shop_id, name, address, user)
    @shop_id = shop_id
    @name = name
    @address = address
    @user = user
  end

  def update_shop
    authenticate_user
    validate_input
    shop = fetch_shop
    update_shop_record(shop)
    log_user_activity
    confirmation_message(shop) # Added method call to return confirmation message
  rescue StandardError => e
    handle_exception(e)
  end

  private

  def authenticate_user
    raise 'Not authorized' unless ApplicationPolicy.new(user, :shop).update?
  end

  def validate_input
    raise 'Name cannot be empty' if name.blank?
    raise 'Address cannot be empty' if address.blank?
    raise 'Invalid shop ID' unless shop_id.is_a?(Integer) && shop_id.positive?
  end

  def fetch_shop
    shop = Shop.find_by(id: shop_id)
    raise 'Shop not found' unless shop
    shop
  end

  def update_shop_record(shop)
    shop.update!(name: name, address: address)
  end

  def log_user_activity
    UserActivity.create!(
      user_id: user.id,
      activity_type: 'shop_update',
      activity_description: "Updated shop ##{shop_id} with new name '#{name}' and address '#{address}'."
    )
  end

  def handle_exception(exception)
    Rails.logger.error(exception.message)
    raise exception
  end

  def confirmation_message(shop)
    "Shop ##{shop.id} has been updated with name '#{shop.name}' and address '#{shop.address}'."
  end
end
