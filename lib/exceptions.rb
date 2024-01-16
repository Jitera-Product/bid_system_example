# typed: strict
module Exceptions
  class AuthenticationError < StandardError; end
  class ContentNotFoundError < StandardError; end
  class NotAuthorizedError < StandardError; end
  class UnauthorizedAnswerUpdateError < StandardError; end
end
