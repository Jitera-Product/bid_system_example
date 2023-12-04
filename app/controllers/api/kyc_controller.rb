class Api::KycController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[create]
  def create
    user_id = params[:user_id]
    personal_info = params[:personal_info]
    document_file = params[:document_file]
    unless user_id.is_a?(Integer)
      return render json: { error: 'Wrong format for user_id' }, status: :bad_request
    end
    unless personal_info.is_a?(Hash)
      return render json: { error: 'Wrong format for personal_info' }, status: :bad_request
    end
    unless document_file.is_a?(ActionDispatch::Http::UploadedFile)
      return render json: { error: 'Wrong format for document_file' }, status: :bad_request
    end
    begin
      result = KycDocuments::CreateService.new(user_id, personal_info, document_file).execute
      if result.success?
        render json: { status: 200, message: "KYC document has been successfully submitted." }, status: :ok
      else
        render json: { error: 'Internal Server Error' }, status: :internal_server_error
      end
    rescue => e
      render json: { error: 'Internal Server Error' }, status: :internal_server_error
    end
  end
end
