
class Api::WalletsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[show destroy]
  before_action :set_wallet, only: %i[destroy]

  def show
    @wallet = Wallet.find_by!('wallets.id = ?', params[:id])
  end

  def destroy
    authorize @wallet, :destroy?

    if @wallet.locked?
      render json: { message: I18n.t('wallet.locked_error') }, status: :forbidden
      return
    elsif @wallet.transactions.exists? || @wallet.deposits.exists?
      render json: { message: I18n.t('wallet.pending_transactions_error') }, status: :unprocessable_entity
      return
    end

    @wallet.soft_delete
    render json: { message: I18n.t('wallet.delete_success') }, status: :ok
  end

  private

  def set_wallet
    @wallet = Wallet.find_by!(id: params[:id])
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { message: e.message }, status: :not_found
  end

  rescue_from Exceptions::WalletDeletionError do |e|
    render json: { message: e.message }, status: :unprocessable_entity
  end

  # Additional rescue_from handlers can be added here as needed.
end
