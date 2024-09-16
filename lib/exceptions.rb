
# typed: strict
module Exceptions
  class AuthenticationError < StandardError; end
  
  class WalletDeletionError < StandardError; end  # This class handles wallet deletion specific errors
end
