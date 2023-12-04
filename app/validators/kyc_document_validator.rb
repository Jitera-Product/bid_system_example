class KycDocumentValidator < ActiveModel::Validator
  def validate(record)
    unless record.user_id.is_a? Integer
      record.errors.add :user_id, 'Wrong format'
    end
    unless record.personal_info.is_a? Hash
      record.errors.add :personal_info, 'Wrong format'
    end
    unless record.document_file.is_a? ActionDispatch::Http::UploadedFile
      record.errors.add :document_file, 'Wrong format'
    end
  end
end
