class Api::KycController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[manual_kyc_verification]
  before_action :validate_params, only: %i[manual_kyc_verification]
  def manual_kyc_verification
    @user = User.find_by('users.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound, 'This KYC information is not found' if @user.blank?
    authorize @user, policy_class: Api::UsersPolicy
    begin
      UserService::ManualKycVerification.new(@user, params[:status]).execute
      render json: { message: 'KYC information verified successfully.', status: @user.reload.kyc_status }, status: :ok
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
  private
  def validate_params
    raise ArgumentError, 'Wrong format' unless params[:id].is_a?(Integer)
    raise ArgumentError, 'Invalid status.' unless ['Verified', 'Not Verified'].include?(params[:status])
  end
end
