class Transactions::ReversalTransaction < Transaction
  belongs_to :authorize_transaction, foreign_key: :referenced_transaction_id, required: true

  validate :no_charge_transaction

  private

  def no_charge_transaction
    if authorize_transaction&.charge_transaction.present?
      errors.add(:base, "An AuthorizeTransaction can only have either ChargeTransaction or ReversalTransaction") 
    end
  end 
end
