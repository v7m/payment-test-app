# frozen_string_literal: true

module ReferencedTransactionMerchantValidatable
  extend ActiveSupport::Concern

  included do
    validate :referenced_transaction_merchant
  end

  def referenced_transaction_merchant
    return if referenced_transaction&.merchant_id == merchant_id

    errors.add(:merchant_id, "Merchant mismatch between referenced and current transactions")
  end
end
