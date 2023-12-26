# FILE PATH: /app/services/shipping_service.rb
class ShippingService
  def list_shippings(params)
    records = Shipping.all
    records = filter_by_address(records, params[:address]) if params[:address].present?
    records = filter_by_post_code(records, params[:post_code]) if params[:post_code].present?
    records = filter_by_phone_number(records, params[:phone_number]) if params[:phone_number].present?
    records = filter_by_bid_id(records, params[:bid_id]) if params[:bid_id].present?
    records = filter_by_status(records, params[:status]) if params[:status].present?
    records = filter_by_full_name(records, params[:full_name]) if params[:full_name].present?
    records = filter_by_email(records, params[:email]) if params[:email].present?
    records = records.order(created_at: :desc)
    paginated_records = records.page(params[:page]).per(params[:limit])

    {
      records: paginated_records,
      pagination: {
        current_page: paginated_records.current_page,
        total_pages: paginated_records.total_pages,
        total_count: paginated_records.total_count
      }
    }
  end

  private

  def filter_by_address(scope, filter_value)
    scope.where('shipping_address LIKE ?', "#{filter_value}%")
  end

  def filter_by_post_code(scope, filter_value)
    scope.where(post_code: filter_value)
  end

  def filter_by_phone_number(scope, filter_value)
    scope.where('phone_number LIKE ?', "#{filter_value}%")
  end

  def filter_by_bid_id(scope, filter_value)
    scope.where(bid_id: filter_value)
  end

  def filter_by_status(scope, filter_value)
    scope.where(status: filter_value)
  end

  def filter_by_full_name(scope, filter_value)
    scope.where('full_name LIKE ?', "#{filter_value}%")
  end

  def filter_by_email(scope, filter_value)
    scope.where('email LIKE ?', "#{filter_value}%")
  end
end
