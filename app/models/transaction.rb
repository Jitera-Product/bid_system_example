class Transaction < ApplicationRecord
  belongs_to :wallet

  enum status: %w[done inprogress rejected], _suffix: true
  enum transaction_type: %w[deposit withdraw bid payback], _suffix: true
  enum reference_type: %w[bid withdraw deposit], _suffix: true

  # validations

  validates :reference_id, presence: true

  validates :reference_id, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 0.0 }

  validates :value, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 0.0 }

  # end for validations

  class << self
  end
end
