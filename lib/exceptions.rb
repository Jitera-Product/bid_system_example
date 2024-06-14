# typed: strict
module Exceptions
  class AuthenticationError < StandardError; end
  class PaginationError < StandardError; end
  class PageNumberError < PaginationError; end
  class PageFormatError < PaginationError; end
end
