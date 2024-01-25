class MessageValidator
  def self.validate_message_content(content)
    raise Exceptions::InvalidParameter, 'Message content cannot be empty.' if content.blank?
    raise Exceptions::InvalidParameter, 'Message content exceeds the maximum length of 512 characters.' if content.length > 512
  end
end
