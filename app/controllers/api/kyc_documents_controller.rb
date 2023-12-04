class Api::KycDocumentsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[manual_verify]
  def manual_verify
    @kyc_document = KycDocument.find_by('kyc_documents.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @kyc_document.blank?
    @kyc_document.update(status: 'Under Review')
    UserMailer.with(user: @kyc_document.user).kyc_review_notification.deliver_later
    @kyc_document.user.update(kyc_status: params[:status])
    render json: { message: 'KYC document status updated successfully', kyc_status: @kyc_document.user.kyc_status }
  end
end
