# frozen_string_literal: true

class Transaction < ApplicationRecord
  PERMITTED_REFERENCE_STATUSES = %w[approved refunded].freeze

  belongs_to :merchant

  enum status: { approved: 0, reversed: 1, refunded: 2, error: 3 }

  validates :type, presence: true
  validates :amount, numericality: { greater_than: 0 }, allow_nil: true
  validates :status, inclusion: { in: statuses.keys }, allow_nil: true
  validates :customer_email, presence: true, email_format: true

  scope :approved_authorize, -> { where(type: "Transactions::AuthorizeTransaction").approved }
  scope :approved_revessed, -> { where(type: "Transactions::AuthorizeTransaction").reversed }
  scope :charge_authorize, -> { where(type: "Transactions::ChargeTransaction").approved }
  scope :charge_reversed, -> { where(type: "Transactions::ChargeTransaction").reversed }
end
