# typed: strict
module Exceptions
  class AuthenticationError < StandardError; end
  class NotAuthorizedError < StandardError; end
  class ChatChannelNotActiveError < StandardError; end
end
