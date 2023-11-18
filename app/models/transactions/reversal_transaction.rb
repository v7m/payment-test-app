# frozen_string_literal: true

class Transactions::ReversalTransaction < Transaction
  include ReferencedTransactionMerchantValidatable

  belongs_to :referenced_transaction, class_name: "Transactions::AuthorizeTransaction"

  validate :no_charge_transaction

  private

  def no_charge_transaction
    return if referenced_transaction&.charge_transactions&.empty?

    errors.add(:base, "An AuthorizeTransaction can only have either ChargeTransaction or ReversalTransaction")
  end
end
