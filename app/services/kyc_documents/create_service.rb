# PATH: /app/services/kyc_documents/create_service.rb
# rubocop:disable Style/ClassAndModuleChildren
class KycDocuments::CreateService
  attr_accessor :params, :user
  def initialize(params, user)
    @params = params
    @user = user
  end
  def execute
    validate_input
    create_kyc_document
    update_user_kyc_status
  end
  private
  def validate_input
    validator = KycDocumentValidator.new(params)
    raise StandardError, validator.errors.full_messages.to_sentence unless validator.valid?
  end
  def create_kyc_document
    KycDocument.create!(
      user_id: user.id,
      document_type: params[:document_type],
      document_file: params[:document_file],
      status: params[:status]
    )
  end
  def update_user_kyc_status
    user.update!(kyc_status: 'Verified')
  end
end
# rubocop:enable Style/ClassAndModuleChildren
