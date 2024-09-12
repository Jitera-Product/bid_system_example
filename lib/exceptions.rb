
# typed: strict
module Exceptions
  class AuthenticationError < StandardError; end
  # Define a new custom exception for Moder email confirmation errors
  class ModerConfirmationError < StandardError
    attr_reader :message
  end
end
