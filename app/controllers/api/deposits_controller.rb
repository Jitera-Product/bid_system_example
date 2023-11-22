class Api::DepositsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show]

  def index
    # inside service params are checked and whiteisted
    @deposits = DepositService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @deposits.total_pages
  end

  def show
    @deposit = Deposit.find_by!('deposits.id = ?', params[:id])
  end

  def create
    @deposit = Deposit.new(create_params)

    return if @deposit.save

    @error_object = @deposit.errors.messages

    render status: :unprocessable_entity
  end

  def create_params
    params.require(:deposits).permit(:value, :user_id, :wallet_id, :status, :payment_method_id)
  end
end
