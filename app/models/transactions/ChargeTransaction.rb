class Transactions::ChargeTransaction < Transaction
  belongs_to :authorize_transaction, foreign_key: :referenced_transaction_id, required: true
  has_many :refund_transactions, foreign_key: :referenced_transaction_id

  validates :amount, presence: true
  validate :no_reversal_transaction

  def no_reversal_transaction
    if authorize_transaction&.reversal_transaction.present?
      errors.add(:base, "An AuthorizeTransaction can only have either ChargeTransaction or ReversalTransaction") 
    end
  end                                
end
