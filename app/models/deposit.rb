class Deposit < ApplicationRecord
  belongs_to :user
  belongs_to :wallet
  belongs_to :payment_method

  enum status: %w[new inprogress done fail], _suffix: true

  # validations

  validates :value, presence: true

  validates :value, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 0.0 }

  # end for validations

  class << self
  end
end
