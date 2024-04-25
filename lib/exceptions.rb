# typed: strict
module Exceptions
  class AuthenticationError < StandardError; end
  
  class UserRegistrationError < StandardError
    attr_reader :status
    def initialize(message, status = :unprocessable_entity); super(message); @status = status; end
  end
end
