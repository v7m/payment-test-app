class Transaction < ApplicationRecord
  belongs_to :merchant, required: true
  belongs_to :referenced_transaction, class_name: "Transaction", foreign_key: :referenced_transaction_id, optional: true
  has_many :follow_transactions, class_name: "Transaction", foreign_key: :referenced_transaction_id

  enum status: { approved: 0, reversed: 1, refunded: 2, error: 3 }

  validates :type, presence: true
  validates :amount, numericality: { greater_than: 0 }, allow_nil: true
  validates :status, inclusion: { in: statuses.keys }, allow_nil: true
  validates :customer_email, presence: true, email_format: true
end
