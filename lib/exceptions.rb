# typed: strict
module Exceptions
  class AuthenticationError < StandardError; end
  class ContentNotFound < StandardError
    def initialize(content_id)
      super("Content with ID #{content_id} not found")
    end
  end
  class InvalidAnswerIdError < StandardError; end
  class InvalidUsefulnessValueError < StandardError; end
end
