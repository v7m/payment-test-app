# frozen_string_literal: true

class Transaction < ApplicationRecord
  PERMITTED_REFERENCE_STATUSES = %w[approved refunded].freeze
  TRANSACTION_TYPES = %w[
    Transactions::AuthorizeTransaction
    Transactions::ChargeTransaction
    Transactions::ReversalTransaction
    Transactions::RefundTransaction
  ].freeze

  belongs_to :merchant

  enum status: { approved: 0, reversed: 1, refunded: 2, error: 3 }

  validates :type, presence: true
  validates :amount, numericality: { greater_than: 0 }, allow_nil: true
  validates :status, inclusion: { in: statuses.keys }, allow_nil: true
  validates :customer_email, presence: true, email_format: true

  statuses.each_key do |status|
    TRANSACTION_TYPES.each do |type|
      scope "#{type.demodulize.underscore.split('_').first}_#{status}", -> { where(status:, type:) }
    end
  end

  TRANSACTION_TYPES.each do |transaction_type|
    define_method("#{transaction_type.demodulize.underscore}?") do
      type == transaction_type
    end
  end
end
