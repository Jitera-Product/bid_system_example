class Request < ApplicationRecord
  # Associations
  belongs_to :user, foreign_key: 'user_id'

  # Validations
  validates :status, presence: true
  validates :description, presence: true

  # Add additional validations and methods below as needed
end
