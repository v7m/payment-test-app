class Transactions::RefundTransaction < Transaction
  include ReferencedTransactionMerchantValidatable

  belongs_to :referenced_transaction, class_name: "Transactions::ChargeTransaction", foreign_key: :referenced_transaction_id, required: true

  validates :amount, presence: true
end
