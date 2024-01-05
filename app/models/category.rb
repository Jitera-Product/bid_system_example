class Category < ApplicationRecord
  # Existing associations
  has_many :product_categories, dependent: :destroy
  has_many :todo_categories, dependent: :destroy # New association for todo_categories

  # The association with Admin should be named 'admin' instead of 'created'
  # and should use the foreign_key 'admin_id' as per the new guidelines
  belongs_to :admin, foreign_key: 'admin_id', class_name: 'Admin'

  # Existing validations
  validates :name, presence: true
  validates :name, length: { in: 0..255 }, if: :name?

  # New validation for 'disabled' field
  validates :disabled, inclusion: { in: [true, false] }

  # Custom methods and class methods (if any) remain unchanged
end
