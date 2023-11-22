class Api::WalletsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[show]

  def show
    @wallet = Wallet.find_by!('wallets.id = ?', params[:id])
  end
end
