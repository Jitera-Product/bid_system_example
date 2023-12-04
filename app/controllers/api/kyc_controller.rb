class Api::KycController < Api::BaseController
  before_action :doorkeeper_authorize!
  before_action :authenticate
  before_action :authorize, only: [:update_kyc_status]
  def update_kyc_status
    id = params[:id]
    status = params[:status]
    # Validate input parameters
    unless id.is_a?(Integer)
      render json: { error: 'Wrong format' }, status: :bad_request
      return
    end
    unless ['Pending', 'Verified', 'Rejected'].include?(status)
      render json: { error: 'Invalid status type' }, status: :bad_request
      return
    end
    begin
      # Call the updateKycStatus function from the KycService
      updated_status = KycService.updateKycStatus(id, status)
      render json: { status: 200, message: 'KYC status updated successfully.' }, status: :ok
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
  private
  def authenticate
    # Authentication logic...
  end
  def authorize
    # Authorization logic...
  end
end
