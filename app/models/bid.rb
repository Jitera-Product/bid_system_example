class Bid < ApplicationRecord
  has_one :shipping, dependent: :destroy

  belongs_to :item,
             class_name: 'BidItem'
  belongs_to :user

  enum status: %w[new paid refund], _suffix: true

  # validations

  validates :price, presence: true

  validates :price, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 0.0 }

  # end for validations

  class << self
  end
end
