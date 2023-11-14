class Transactions::RefundTransaction < Transaction
  belongs_to :charge_transaction, foreign_key: :referenced_transaction_id, required: true

  validates :amount, presence: true
end
