class PasswordValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[^]{8,}\z/
      record.errors[attribute] << (options[:message] || "is not a valid password")
    end
  end
end
