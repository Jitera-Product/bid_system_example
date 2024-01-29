# typed: strict
module Exceptions
  class AuthenticationError < StandardError; end
  class NotAuthorizedError < StandardError; end
  # ChatChannelNotActiveError is already defined

  # Define custom exceptions for chat channel creation errors
  class BidItemNotFoundError < StandardError; end
  class BidItemCompletedError < StandardError; end
  class ChatChannelExistsError < StandardError; end
  class BidItemNotDoneError < StandardError; end
  # Add any other custom exceptions as needed
end
