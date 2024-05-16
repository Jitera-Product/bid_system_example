# typed: strict
module Exceptions
  class AuthenticationError < StandardError; end
  class InvalidParametersError < StandardError; end
  class UnauthorizedAccessError < StandardError; end
  class ProductCreationError < StandardError; end
end
