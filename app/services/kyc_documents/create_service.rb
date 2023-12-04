# PATH: /app/services/kyc_documents/create_service.rb
# rubocop:disable Style/ClassAndModuleChildren
class KycDocuments::CreateService
  attr_accessor :params, :user
  def initialize(params, user)
    @params = params
    @user = user
  end
  def execute
    validate_params
    document = KycDocument.create!(params)
    user.update!(kyc_status: 'Verified')
    document
  rescue StandardError => e
    { error: e.message }
  end
  private
  def validate_params
    # Add your validation logic here
    # Raise an error if validation fails
  end
end
# rubocop:enable Style/ClassAndModuleChildren
