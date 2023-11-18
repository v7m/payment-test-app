class Transactions::ReversalTransaction < Transaction
  include ReferencedTransactionMerchantValidatable

  belongs_to :referenced_transaction, class_name: "Transactions::AuthorizeTransaction", foreign_key: :referenced_transaction_id, required: true

  validate :no_charge_transaction

  private

  def no_charge_transaction
    return unless referenced_transaction.present?

    if referenced_transaction.charge_transactions.any?
      errors.add(:base, "An AuthorizeTransaction can only have either ChargeTransaction or ReversalTransaction") 
    end
  end 
end
