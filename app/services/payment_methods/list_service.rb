# FILE PATH: /app/services/payment_methods/list_service.rb
module PaymentMethods
  class ListService < BaseService
    attr_accessor :params

    def initialize(params)
      @params = params
    end

    def call
      apply_filters
      order_records
      paginate_records
      { records: @records, pagination: pagination_details }
    end

    private

    def apply_filters
      @records = PaymentMethod.all
      user_id_filter
      primary_filter
      method_filter
    end

    def user_id_filter
      return if params.dig(:wallets, :user_id).blank?

      @records = @records.where(user_id: params.dig(:wallets, :user_id))
    end

    def primary_filter
      return if params.dig(:wallets, :primary).blank?

      @records = @records.where(primary: params.dig(:wallets, :primary))
    end

    def method_filter
      return if params.dig(:wallets, :method).blank?

      @records = @records.where(method: params.dig(:wallets, :method))
    end

    def order_records
      @records = @records.order(created_at: :desc)
    end

    def paginate_records
      @records = PaginationHelper.paginate(@records, params.dig(:pagination_page), params.dig(:pagination_limit))
    end

    def pagination_details
      PaginationHelper.pagination_details(@records, params.dig(:pagination_page), params.dig(:pagination_limit))
    end
  end
end
