class Api::PaymentMethodsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show]
  def index
    @payment_methods = PaymentMethodService::Index.call(current_resource_owner)
    @total_pages = @payment_methods.total_pages
    render 'api/payment_methods/index'
  end
  def show
    @payment_method = PaymentMethod.find_by!('payment_methods.id = ?', params[:id])
    render 'api/payment_methods/show'
  end
  def create
    @payment_method = PaymentMethod.new(create_params)
    if @payment_method.save
      render 'api/payment_methods/create', status: :created
    else
      @error_object = @payment_method.errors.messages
      render 'api/payment_methods/error', status: :unprocessable_entity
    end
  end
  private
  def create_params
    params.require(:payment_method).permit(:user_id, :primary, :method)
  end
end
