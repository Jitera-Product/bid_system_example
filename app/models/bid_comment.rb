class BidComment < ApplicationRecord
  # associations
  belongs_to :bid
  belongs_to :user
  # validations
  validates :comment, presence: true
  validates :comment, length: { in: 1..255 }, if: :comment?
  # timestamps
  attribute :created_at, :datetime, default: -> { Time.now }
  attribute :updated_at, :datetime, default: -> { Time.now }
end
