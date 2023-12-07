class Test < ApplicationRecord
  # validations
  validates :title, length: { maximum: 255 }, allow_nil: false
end
