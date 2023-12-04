class KycDocumentValidator < ActiveModel::Validator
  def validate(record)
    unless record.document_file.content_type.start_with? 'image'
      record.errors.add :document_file, 'needs to be an image'
    end
    unless record.document_file.size < 5.megabytes
      record.errors.add :document_file, 'size should be less than 5MB'
    end
    unless ['passport', 'driver_license', 'national_id'].include? record.document_type
      record.errors.add :document_type, 'is not a valid document type'
    end
    unless record.id.present?
      record.errors.add :id, 'is required'
    end
    unless record.name.present?
      record.errors.add :name, 'is required'
    end
    unless ['verified', 'unverified'].include? record.kyc_status
      record.errors.add :kyc_status, 'is not a valid status'
    end
    unless ['pending', 'approved', 'rejected'].include? record.status
      record.errors.add :status, 'is not a valid status'
    end
  end
end
