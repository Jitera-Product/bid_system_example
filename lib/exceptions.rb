# typed: strict
module Exceptions
  class AuthenticationError < StandardError; end
  class InactiveChatSessionError < StandardError; end
  class MessageTooLongError < StandardError; end
  class MessageLimitExceededError < StandardError; end
end
