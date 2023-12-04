class Api::KycController < Api::BaseController
  before_action :doorkeeper_authorize!, only: [:verify_kyc]
  before_action :set_user, only: [:verify_kyc]
  before_action :validate_kyc_status, only: [:verify_kyc]
  def verify_kyc
    authorize @user, policy_class: Api::UsersPolicy
    if @user.update(kyc_status: params[:kyc_status])
      render json: { status: 200, message: "KYC status updated successfully." }
    else
      @error_object = @user.errors.messages
      render status: :unprocessable_entity
    end
  end
  private
  def set_user
    @user = User.find_by(id: params[:id])
    raise ActiveRecord::RecordNotFound if @user.blank?
  end
  def validate_kyc_status
    valid_statuses = ['Verified', 'Not Verified', 'Pending']
    unless valid_statuses.include?(params[:kyc_status])
      render json: { error: 'Invalid KYC status.' }, status: :bad_request
    end
  end
end
