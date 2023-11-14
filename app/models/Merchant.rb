class Merchant < ApplicationRecord
  has_many :transactions, dependent: :destroy
  has_many :authorize_transactions, class_name: "Transactions::AuthorizeTransaction", dependent: :destroy
  has_many :charge_transactions, class_name: "Transactions::ChargeTransaction", dependent: :destroy
  has_many :refund_transactions, class_name: "Transactions::RefundTransaction", dependent: :destroy
  has_many :reversal_transactions, class_name: "Transactions::ReversalTransaction", dependent: :destroy

  enum status: { inactive: 0, active: 1 }

  validates :name, presence: true
  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :email, presence: true, uniqueness: true, email_format: true
end
