class Api::WalletsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[show destroy]
  before_action :set_wallet, only: %i[destroy]

  def show
    @wallet = Wallet.find_by!('wallets.id = ?', params[:id])
  end

  def destroy
    authorize @wallet, :destroy?

    if @wallet.locked
      render json: { message: I18n.t('wallet.locked_error') }, status: :forbidden
      return
    elsif @wallet.transactions.inprogress.exists? || @wallet.transactions.pending.exists?
      render json: { message: I18n.t('wallet.pending_transactions_error') }, status: :unprocessable_entity
      return
    end

    Wallet.transaction do
      @wallet.update!(deleted_at: Time.current)
      @wallet.transactions.update_all(deleted_at: Time.current)
      @wallet.deposits.update_all(deleted_at: Time.current)
    end
    render json: { message: I18n.t('wallet.delete_success') }, status: :ok
  end

  private

  def set_wallet
    @wallet = Wallet.find_by!(id: params[:id])
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { message: e.message }, status: :not_found
  end
end
