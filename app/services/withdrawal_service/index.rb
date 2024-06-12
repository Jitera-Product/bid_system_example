# rubocop:disable Style/ClassAndModuleChildren
class WithdrawalService::Index
  attr_accessor :params, :records, :query

  def initialize(params, current_user = nil)
    @params = params
    @current_user = current_user
    @records = Withdrawal.all
  end

  def execute
    filter_by_status
    filter_by_value
    filter_by_approved_id
    filter_by_payment_method_id
    order
    paginate
  end

  private

  def filter_by_status
    return if params[:status].nil?

    @records = @records.where(status: params[:status])
  end

  def filter_by_value
    return if params[:value].nil?

    @records = @records.where(value: params[:value])
  end

  def filter_by_approved_id
    return if params[:approved_id].nil?

    @records = @records.where(approved_id: params[:approved_id])
  end

  def filter_by_payment_method_id
    return if params[:payment_method_id].nil?

    @records = @records.where(payment_method_id: params[:payment_method_id])
  end

  def order
    @records = @records.order(created_at: :desc)
  end

  def paginate
    page = params.fetch(:page, 1)
    per_page = params.fetch(:per_page, 20)
    @records = @records.page(page).per(per_page)
  end
end
# rubocop:enable Style/ClassAndModuleChildren