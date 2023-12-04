# typed: strict
module Exceptions
  class AuthenticationError < StandardError; end
  class KycDocumentSubmissionError < StandardError
    def initialize(msg="KYC document submission failed. Please try again.")
      super
    end
  end
end
