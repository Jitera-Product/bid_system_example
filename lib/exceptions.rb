# typed: strict
module Exceptions
  class AuthenticationError < StandardError; end
  # Custom exception for inactive chat channel
  class ChatChannelNotActiveError < StandardError; end
end
