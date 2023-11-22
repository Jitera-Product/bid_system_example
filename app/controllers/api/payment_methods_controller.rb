class Api::PaymentMethodsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show]

  def index
    # inside service params are checked and whiteisted
    @payment_methods = PaymentMethodService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @payment_methods.total_pages
  end

  def show
    @payment_method = PaymentMethod.find_by!('payment_methods.id = ?', params[:id])
  end

  def create
    @payment_method = PaymentMethod.new(create_params)

    return if @payment_method.save

    @error_object = @payment_method.errors.messages

    render status: :unprocessable_entity
  end

  def create_params
    params.require(:wallets).permit(:user_id, :primary, :method)
  end
end
