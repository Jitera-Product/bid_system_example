class Api::WithdrawalsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show]

  def index
    # Instantiate the service with permitted params and current_resource_owner
    @withdrawals = WithdrawalService::Index.new(create_params, current_resource_owner).execute
    @total_pages = @withdrawals.total_pages
  end

  def show
    @withdrawal = Withdrawal.find_by!('withdrawals.id = ?', params[:id])
  end

  def create
    @withdrawal = Withdrawal.new(create_params)

    return if @withdrawal.save

    @error_object = @withdrawal.errors.messages

    render status: :unprocessable_entity
  end

  # Update create_params to include pagination and correct the typo in approved_id
  def create_params
    params.require(:withdrawals).permit(:status, :value, :approved_id, :payment_method_id, :pagination_page, :pagination_limit)
  end
end
