class Transactions::AuthorizeTransaction < Transaction
  has_many :charge_transactions, foreign_key: :referenced_transaction_id
  has_many :reversal_transactions, foreign_key: :referenced_transaction_id

  validates :amount, presence: true
end
