class Api::KycDocumentsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update]
  # Other methods...
  def update_kyc_status
    @user = User.find_by('users.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @user.blank?
    authorize @user, policy_class: Api::UsersPolicy
    kyc_status = params[:kyc_status]
    status = params[:status]
    if kyc_status == 'Verified' && status == 'Verified'
      @user.update(kyc_status: 'Verified')
      @user.kyc_documents.update_all(status: 'Verified')
    elsif kyc_status == 'Not Verified' && status == 'Not Verified'
      @user.update(kyc_status: 'Not Verified')
      @user.kyc_documents.update_all(status: 'Not Verified')
    end
    UserMailer.with(user: @user).kyc_status_email.deliver_later
    render json: { kyc_status: @user.kyc_status, document_status: @user.kyc_documents.first.status }, status: :ok
  end
end
