class KycDocumentValidator
  def initialize(kyc_document)
    @kyc_document = kyc_document
  end
  def validate
    check_format && check_validity && check_input_match
  end
  private
  def check_format
    valid_formats = ['pdf', 'jpeg', 'jpg', 'png']
    if valid_formats.include?(@kyc_document.document_file.file.extension.downcase)
      true
    else
      @error_message = "Invalid file format. Please upload a PDF, JPEG, or PNG file."
      false
    end
  end
  def check_validity
    if @kyc_document.status == 'expired'
      @error_message = "Your document is expired. Please upload a valid document."
      false
    else
      true
    end
  end
  def check_input_match
    if @kyc_document.user.name != @kyc_document.document_file.file.name
      @error_message = "The information you entered does not match the document. Please check your input and try again."
      false
    else
      true
    end
  end
  def error_message
    @error_message
  end
end
