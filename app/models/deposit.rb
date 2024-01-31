
class Deposit < ApplicationRecord
  belongs_to :user
  belongs_to :wallet
  belongs_to :payment_method

  enum status: { new: 0, inprogress: 1, done: 2, fail: 3 }, _suffix: true

  attribute :transaction_code, :string
  # validations

  validates :value, presence: true

  validates :value, numericality: { greater_than_or_equal_to: 0.01 }

  # end for validations

  class << self
  end
end
