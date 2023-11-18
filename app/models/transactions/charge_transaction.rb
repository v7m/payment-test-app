class Transactions::ChargeTransaction < Transaction
  include ReferencedTransactionMerchantValidatable

  belongs_to :referenced_transaction, class_name: "Transactions::AuthorizeTransaction", foreign_key: :referenced_transaction_id, required: true
  has_many :refund_transactions, foreign_key: :referenced_transaction_id

  validates :amount, presence: true
  validate :no_reversal_transaction

  private

  def no_reversal_transaction
    return unless referenced_transaction.present?

    if referenced_transaction.reversal_transactions.any?
      errors.add(:base, "An AuthorizeTransaction can only have either ChargeTransaction or ReversalTransaction") 
    end
  end
end
