# typed: strict
module Exceptions
  class MissingFieldsError < StandardError
    attr_reader :status, :message
    def initialize(message = I18n.t('controller.error.missing_fields'), status = 422)
      super(message)
      @status = status
    end
  end

  class PasswordMismatchError < StandardError
    attr_reader :status, :message
    def initialize(message = I18n.t('controller.error.password_mismatch'), status = 422)
      super(message)
      @status = status
    end
  end

  class InvalidEmailFormatError < StandardError
    attr_reader :status, :message
    def initialize(message = I18n.t('controller.error.invalid_email_format'), status = 422)
      super(message)
      @status = status
    end
  end

  class UserAlreadyExistsError < StandardError
    attr_reader :status, :message
    def initialize(message = I18n.t('controller.error.user_already_exists'), status = 409)
      super(message)
      @status = status
    end
  end

  class AuthenticationError < StandardError; end
  
  class UserRegistrationError < StandardError
    attr_reader :status
    def initialize(message, status = :unprocessable_entity); super(message); @status = status; end
  end
end
