# frozen_string_literal: true

class Transactions::RefundTransaction < Transaction
  include ReferencedTransactionMerchantValidatable

  belongs_to :referenced_transaction, class_name: "Transactions::ChargeTransaction"

  validates :amount, presence: true
end
