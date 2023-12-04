class BidItemValidator < ActiveModel::Validator
  def validate(record)
    unless record.name.present?
      record.errors.add(:name, "can't be blank")
    end
    unless record.description.present?
      record.errors.add(:description, "can't be blank")
    end
    unless record.start_price.present? && record.start_price.is_a?(Float)
      record.errors.add(:start_price, "must be a float")
    end
    unless record.current_price.present? && record.current_price.is_a?(Float)
      record.errors.add(:current_price, "must be a float")
    end
    unless record.status.present? && ['open', 'closed', 'cancelled'].include?(record.status)
      record.errors.add(:status, "must be one of: open, closed, cancelled")
    end
  end
end
