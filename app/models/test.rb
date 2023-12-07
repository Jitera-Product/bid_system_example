class Test < ApplicationRecord
  # validations
  validates :name, length: { maximum: 255 }, allow_nil: false
end
