class Transaction < ApplicationRecord
  PERMITTED_REFERENCE_STATUSES = %w(approved refunded).freeze

  belongs_to :merchant, required: true

  enum status: { approved: 0, reversed: 1, refunded: 2, error: 3 }

  validates :type, presence: true
  validates :amount, numericality: { greater_than: 0 }, allow_nil: true
  validates :status, inclusion: { in: statuses.keys }, allow_nil: true
  validates :customer_email, presence: true, email_format: true
end
