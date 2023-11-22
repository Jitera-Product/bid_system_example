class Api::WithdrawalsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show]

  def index
    # inside service params are checked and whiteisted
    @withdrawals = WithdrawalService::Index.new(params.permit!, current_resource_owner).execute
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

  def create_params
    params.require(:withdrawals).permit(:status, :value, :aprroved_id, :payment_method_id)
  end
end
