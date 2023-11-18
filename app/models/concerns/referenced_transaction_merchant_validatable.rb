module ReferencedTransactionMerchantValidatable
  extend ActiveSupport::Concern

  included do
    validate :referenced_transaction_merchant
  end

  def referenced_transaction_merchant
    return unless referenced_transaction.present?

    if merchant_id != referenced_transaction.merchant_id
      errors.add(:merchant_id, "Merchant mismatch between referenced and current transactions") 
    end
  end
end
