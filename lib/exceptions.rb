# typed: strict
module Exceptions
  class AuthenticationError < StandardError; end
  class ChatChannelNotFoundError < StandardError; end
  class ChatChannelDisabledError < StandardError; end
end
