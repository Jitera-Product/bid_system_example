class UserIdValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless User.exists?(value)
      record.errors[attribute] << (options[:message] || "is not an existing user")
    end
  end
end
