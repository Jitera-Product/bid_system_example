# typed: strict
module Exceptions
  class AuthenticationError < StandardError; end
  class NotAuthorizedError < StandardError; end
  class ChatChannelNotActiveError < StandardError; end
  class BidItemNotFoundError < StandardError; end
  class BidItemCompletedError < StandardError; end
  class ChatChannelExistsError < StandardError; end
  class BidItemNotDoneError < StandardError; end
  # Add any other custom exceptions as needed
end
