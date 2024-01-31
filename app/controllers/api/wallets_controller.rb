
class Api::WalletsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[show]
  before_action :set_wallet, only: %i[destroy]

  def show
    @wallet = Wallet.find_by!('wallets.id = ?', params[:id])
  end

  def destroy
    if @wallet.locked
      base_render_unprocessable_entity(I18n.t('wallet.errors.locked'))
    elsif @wallet.transactions.pending.exists?
      base_render_unprocessable_entity(I18n.t('wallet.errors.pending_transactions'))
    else
      Wallet.transaction do
        @wallet.soft_delete
        @wallet.deposits.update_all(deleted_at: Time.current)
        @wallet.transactions.update_all(deleted_at: Time.current)
      end
      render json: { message: I18n.t('wallet.success.deleted') }, status: :ok
    end
  end

  private

  def set_wallet
    @wallet = Wallet.find_by!(id: params[:id])
  end
end
