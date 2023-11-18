# frozen_string_literal: true

class Transactions::ChargeTransaction < Transaction
  include ReferencedTransactionMerchantValidatable

  belongs_to :referenced_transaction, class_name: "Transactions::AuthorizeTransaction"
  has_many :refund_transactions, foreign_key: :referenced_transaction_id,
                                 dependent: :destroy,
                                 inverse_of: :referenced_transaction

  validates :amount, presence: true
  validate :no_reversal_transaction

  private

  def no_reversal_transaction
    return if referenced_transaction&.reversal_transactions&.empty?

    errors.add(:base, "An AuthorizeTransaction can only have either ChargeTransaction or ReversalTransaction")
  end
end
