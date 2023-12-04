# rubocop:disable Style/ClassAndModuleChildren
class Users::UpdateKycStatusService
  def execute(user_id, new_kyc_status, document_type, document_file, status)
    user = User.find_by(id: user_id)
    raise Exception.new("User not found") if user.nil?
    ActiveRecord::Base.transaction do
      user.update!(kyc_status: new_kyc_status)
      KycDocument.create!(user: user, document_type: document_type, document_file: document_file, status: status)
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
